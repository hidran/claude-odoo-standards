from odoo import Command, api, fields, models


class SaleOrder(models.Model):
    _inherit = "sale.order"

    acme_priority = fields.Selection(
        selection=[("low", "Low"), ("high", "High")],
        string="ACME Priority",
        default="low",
    )
    acme_express_count = fields.Integer(
        string="Express Lines",
        compute="_compute_acme_express_count",
        store=True,
    )

    @api.depends("order_line.product_uom_qty")
    def _compute_acme_express_count(self):
        for order in self:
            order.acme_express_count = sum(
                1 for line in order.order_line if line.product_uom_qty >= 10
            )

    def action_add_sample_line(self):
        """Ejemplo de Command (las tuplas mágicas (0,0,{}) son del estilo antiguo)."""
        self.ensure_one()
        product = self.env["product.product"].search([], limit=1)
        if product:
            self.order_line = [
                Command.create({"product_id": product.id, "product_uom_qty": 1})
            ]
