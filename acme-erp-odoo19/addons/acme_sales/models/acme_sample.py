from odoo import api, fields, models


class AcmeSample(models.Model):
    _name = "acme.sample"
    _description = "ACME Sample Record"
    _order = "sequence, name"

    name = fields.Char(required=True)
    sequence = fields.Integer(default=10)
    amount = fields.Float()
    note = fields.Text()
    state = fields.Selection(
        selection=[("draft", "Draft"), ("done", "Done")],
        default="draft",
        required=True,
    )

    def action_done(self):
        # Diff mínimo, una responsabilidad.
        self.write({"state": "done"})

    @api.depends("name", "sequence")
    def _compute_display_name(self):
        # Odoo 17+: reemplaza al deprecado name_get()
        for record in self:
            record.display_name = f"[{record.sequence}] {record.name or ''}"
