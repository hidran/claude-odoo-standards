from odoo.tests import tagged
from odoo.tests.common import TransactionCase


@tagged("post_install", "-at_install")
class TestAcmeSample(TransactionCase):

    def test_display_name(self):
        rec = self.env["acme.sample"].create({"name": "Foo", "sequence": 5})
        self.assertEqual(rec.display_name, "[5] Foo")

    def test_action_done(self):
        rec = self.env["acme.sample"].create({"name": "Bar"})
        rec.action_done()
        self.assertEqual(rec.state, "done")
