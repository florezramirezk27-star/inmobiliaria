#!/bin/bash
# =====================================================================
#  unificar-estilos.sh
#  Aplica a las JSP que NO se reescribieron a mano:
#     1. fuente Bricolage+Karla  →  Inter
#     2. Bootstrap Icons (CDN)
#     3. enlace a css/estilos.css si faltaba
#
#  Solo toca el <head>. No modifica ni una línea de lógica:
#  ningún ${...}, <c:...>, form, input ni parámetro se altera.
#  Es idempotente: se puede correr varias veces sin duplicar nada.
# =====================================================================
set -e
cd ~/inmobiliaria/src/main/webapp

INTER='<link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800\&display=swap" rel="stylesheet">'

ICONOS='<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">'

ARCHIVOS="
favoritos.jsp
citas-propiedad.jsp
mis-citas.jsp
formulario-propiedad.jsp
WEB-INF/views/auth/confirmar-logout.jsp
WEB-INF/views/cliente/documentos.jsp
WEB-INF/views/cliente/formulario-solicitud.jsp
WEB-INF/views/cliente/mis-solicitudes.jsp
WEB-INF/views/inmobiliaria/dashboard.jsp
WEB-INF/views/admin/auditoria.jsp
WEB-INF/views/admin/dashboard.jsp
WEB-INF/views/admin/reportes.jsp
WEB-INF/views/admin/usuarios.jsp
"

for f in $ARCHIVOS; do
    [ -f "$f" ] || { echo "  -- no existe: $f"; continue; }

    # --- 1. Bricolage + Karla → Inter (el enlace ocupa dos líneas) ---
    perl -0777 -i -pe '
        s{<link\s+href="https://fonts\.googleapis\.com/css2\?family=Bricolage[^"]*"\s*\n?\s*rel="stylesheet">}
         {<link href="https://fonts.googleapis.com/css2?family=Inter:wght\@400;500;600;700;800&display=swap" rel="stylesheet">}gs;
    ' "$f"

    # --- 2. Bootstrap Icons justo después del CSS de Bootstrap ---
    if ! grep -q "bootstrap-icons" "$f"; then
        perl -0777 -i -pe '
            s{(<link[^>]*bootstrap\@5\.3\.3/dist/css/bootstrap\.min\.css[^>]*>)}
             {$1\n\n    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons\@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">}s;
        ' "$f"
    fi

    # --- 3. Inter para las que nunca tuvieron fuente propia ---
    if ! grep -q "family=Inter" "$f"; then
        perl -0777 -i -pe '
            s{(<link[^>]*bootstrap\@5\.3\.3/dist/css/bootstrap\.min\.css[^>]*>)}
             {<link rel="preconnect" href="https://fonts.googleapis.com">\n    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>\n    <link href="https://fonts.googleapis.com/css2?family=Inter:wght\@400;500;600;700;800&display=swap" rel="stylesheet">\n\n    $1}s;
        ' "$f"
    fi

    # --- 4. estilos.css si faltaba ---
    if ! grep -q "estilos.css" "$f"; then
        perl -0777 -i -pe '
            s{(</head>)}
             {    <link rel="stylesheet" href="\$\{pageContext.request.contextPath\}/css/estilos.css">\n$1}s;
        ' "$f"
    fi

    echo "  OK  $f"
done

echo ""
echo "Listo. Verificación:"
for f in $ARCHIVOS; do
    [ -f "$f" ] || continue
    i=$(grep -c "family=Inter" "$f" || true)
    b=$(grep -c "bootstrap-icons" "$f" || true)
    e=$(grep -c "estilos.css" "$f" || true)
    v=$(grep -c "Bricolage" "$f" || true)
    printf "  Inter:%s  Iconos:%s  CSS:%s  Viejo:%s   %s\n" "$i" "$b" "$e" "$v" "$f"
done
