#!/bin/bash
# =====================================================================
#  INSTALAR.sh — aplica el rediseño completo
#  Ejecutar desde ~/inmobiliaria  tras descomprimir el ZIP.
# =====================================================================
set -e
cd ~/inmobiliaria

echo "=================================================="
echo " 1/4  Respaldo"
echo "=================================================="
if [ -d .git ]; then
    git add -A >/dev/null 2>&1 || true
    git commit -m "backup antes de rediseño UI" >/dev/null 2>&1 \
        && echo "  Commit de respaldo creado." \
        || echo "  Sin cambios que respaldar (ya estaba limpio)."
else
    BK="backup-ui-$(date +%Y%m%d-%H%M%S)"
    cp -r src "$BK"
    echo "  Copia en: $BK/"
fi

echo ""
echo "=================================================="
echo " 2/4  Unificar tipografía e iconos (13 pantallas)"
echo "=================================================="
bash unificar-estilos.sh

echo ""
echo "=================================================="
echo " 3/4  Compilar"
echo "=================================================="
export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home
mvn -q clean package

echo ""
echo "=================================================="
echo " 4/4  Desplegar"
echo "=================================================="
TOMCAT=~/tools/apache-tomcat-8.5.100
rm -rf "$TOMCAT/webapps/inmobiliaria/"
rm -rf "$TOMCAT/work/Catalina/localhost/inmobiliaria/"
cp target/inmobiliaria.war "$TOMCAT/webapps/"
echo "  WAR copiado."

echo ""
echo "LISTO. Ahora reinicia Tomcat 8.5 desde el Tomcat Control:"
echo "   detener  →  esperar rojo  →  iniciar  →  esperar verde"
echo ""
echo "Luego abre:  http://localhost:8081/inmobiliaria/"
