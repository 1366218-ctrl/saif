import importlib.util
import io
import os
import sys
import unittest
from pathlib import Path
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[1]
MODULE_PATH = ROOT / "scripts" / "ai-review.py"
SPEC = importlib.util.spec_from_file_location("saif_ai_review", MODULE_PATH)
review = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = review
SPEC.loader.exec_module(review)


class AIReviewTests(unittest.TestCase):
    def test_claude_request_uses_configured_version_and_extracts_text(self):
        response = {"content": [{"type": "text", "text": "Claude finding"}]}
        with patch.object(review, "request_json", return_value=response) as mocked:
            result = review.review_with_claude("review prompt", "test-key")

        self.assertEqual(result, "Claude finding")
        args, kwargs = mocked.call_args
        self.assertEqual(args[0], "https://api.anthropic.com/v1/messages")
        self.assertEqual(args[1]["x-api-key"], "test-key")
        self.assertEqual(args[1]["anthropic-version"], "2026-10-21")
        self.assertEqual(args[2]["model"], review.CLAUDE_MODEL)

    def test_gemini_request_uses_generate_content_and_extracts_text(self):
        response = {
            "candidates": [
                {"content": {"parts": [{"text": "Gemini finding"}]}}
            ]
        }
        with patch.object(review, "request_json", return_value=response) as mocked:
            result = review.review_with_gemini("review prompt", "test-key")

        self.assertEqual(result, "Gemini finding")
        args, kwargs = mocked.call_args
        self.assertIn(":generateContent", args[0])
        self.assertEqual(args[1]["x-goog-api-key"], "test-key")
        self.assertEqual(args[2]["contents"][0]["parts"][0]["text"], "review prompt")

    def test_gemini_empty_candidates_raise_clear_error(self):
        with patch.object(review, "request_json", return_value={"candidates": []}):
            with self.assertRaisesRegex(RuntimeError, "no candidates"):
                review.review_with_gemini("review prompt", "test-key")

    def test_diff_is_truncated_and_marked(self):
        original_limit = review.MAX_DIFF_CHARS
        review.MAX_DIFF_CHARS = 5
        try:
            with patch.object(review.urllib.request, "urlopen", return_value=io.BytesIO(b"123456789")):
                result = review.get_pull_request_diff("owner/repo", 7, "token")
        finally:
            review.MAX_DIFF_CHARS = original_limit

        self.assertTrue(result.startswith("12345"))
        self.assertIn("DIFF TRUNCATED", result)

    def test_invalid_pr_number_stops_before_network_access(self):
        env = {
            "PR_NUMBER": "0",
            "GITHUB_REPOSITORY": "owner/repo",
            "GITHUB_TOKEN": "token",
            "ANTHROPIC_API_KEY": "claude",
            "GEMINI_API_KEY": "gemini",
        }
        with patch.dict(os.environ, env, clear=True):
            with patch.object(review, "get_pull_request_diff") as get_diff:
                self.assertEqual(review.main(), 2)
                get_diff.assert_not_called()

    def test_invalid_repository_stops_before_network_access(self):
        env = {
            "PR_NUMBER": "3",
            "GITHUB_REPOSITORY": "../unexpected",
            "GITHUB_TOKEN": "token",
            "ANTHROPIC_API_KEY": "claude",
            "GEMINI_API_KEY": "gemini",
        }
        with patch.dict(os.environ, env, clear=True):
            with patch.object(review, "get_pull_request_diff") as get_diff:
                self.assertEqual(review.main(), 2)
                get_diff.assert_not_called()


if __name__ == "__main__":
    unittest.main()
