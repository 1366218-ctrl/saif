import unittest

from disk_inventory import inventory


class DiskInventoryTests(unittest.TestCase):
    def setUp(self):
        self.data = {
            "blockdevices": [
                {
                    "name": "nvme0n1", "path": "/dev/nvme0n1",
                    "type": "disk", "size": 512 * 1024**3,
                    "model": "Internal SSD", "tran": "nvme",
                    "rm": False, "ro": False, "mountpoints": [None],
                    "children": [{
                        "name": "nvme0n1p2", "path": "/dev/nvme0n1p2",
                        "type": "part", "mountpoints": ["/"],
                    }],
                },
                {
                    "name": "sda", "path": "/dev/sda", "type": "disk",
                    "size": 256 * 1024**3, "model": "External SSD",
                    "tran": "usb", "rm": False, "ro": False,
                    "mountpoints": [None],
                    "children": [{
                        "name": "sda1", "path": "/dev/sda1",
                        "type": "part", "mountpoints": [None],
                    }],
                },
                {
                    "name": "sdb", "path": "/dev/sdb", "type": "disk",
                    "size": 64 * 1024**3, "model": "Live USB",
                    "tran": "usb", "rm": True, "ro": False,
                    "mountpoints": [None],
                    "children": [{
                        "name": "sdb1", "path": "/dev/sdb1",
                        "type": "part", "mountpoints": ["/run/saif/live"],
                    }],
                },
                {
                    "name": "sdc", "path": "/dev/sdc", "type": "disk",
                    "size": 128 * 1024**3, "model": "Candidate SSD",
                    "tran": "sata", "rm": False, "ro": False,
                    "mountpoints": [None],
                    "children": [{
                        "name": "sdc1", "path": "/dev/sdc1",
                        "type": "part", "mountpoints": [None],
                    }],
                },
            ]
        }

    def test_excludes_root_live_usb_and_usb_transport(self):
        result = inventory(self.data, "/dev/sdb", "/dev/nvme0n1p2")
        by_path = {disk["path"]: disk for disk in result["disks"]}
        self.assertFalse(by_path["/dev/nvme0n1"]["eligible"])
        self.assertIn("system-root", by_path["/dev/nvme0n1"]["excluded_reasons"])
        self.assertFalse(by_path["/dev/sdb"]["eligible"])
        self.assertIn("live-media", by_path["/dev/sdb"]["excluded_reasons"])
        self.assertFalse(by_path["/dev/sda"]["eligible"])
        self.assertIn("usb-transport", by_path["/dev/sda"]["excluded_reasons"])
        self.assertTrue(by_path["/dev/sdc"]["eligible"])

    def test_requires_explicit_live_media_device(self):
        with self.assertRaises(ValueError):
            inventory(self.data, "", "/dev/nvme0n1p2")
        with self.assertRaises(ValueError):
            inventory(self.data, "/dev/sdb")

    def test_never_enables_installation(self):
        result = inventory(self.data, "/dev/sdb")
        self.assertFalse(result["installation_enabled"])
        self.assertEqual(result["mode"], "read-only-inventory")


if __name__ == "__main__":
    unittest.main()
