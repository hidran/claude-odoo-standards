---
description: Genera/limpia .po con adaptación regional del español (LatAm)
---
Para el módulo `$1`, gestiona las traducciones en `i18n/`:

1. Extrae los términos traducibles.
2. Completa/actualiza `es.po` en español neutro de LatAm.
3. Si se indica región (`$2` = ec | do | mx), crea/ajusta `es_EC.po`, `es_DO.po`
   o `es_MX.po` adaptando vocabulario local sin alterar el sentido.
4. Mantén cabeceras .po válidas y `Plural-Forms` correcto.
