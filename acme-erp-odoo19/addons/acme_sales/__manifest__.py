{
    "name": "ACME Sales Extensions",
    "version": "19.0.1.0.0",
    "category": "Sales",
    "summary": "Módulo de ejemplo fijado a Odoo 19.0 (sintaxis correcta de versión)",
    "author": "ACME / [Empresa]",
    "license": "LGPL-3",
    "depends": ["sale_management"],
    "data": [
        "security/ir.model.access.csv",
        "views/acme_sample_views.xml",
        "views/sale_order_views.xml",
    ],
    "installable": True,
    "application": False,
}
