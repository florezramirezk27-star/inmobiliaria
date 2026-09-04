<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%--
    formulario-propiedad.jsp — crea o edita una propiedad.

    No se accede directamente: PropiedadFormServlet (mapeado a
    /propiedades/formulario) hace el forward aquí, tanto en GET
    (formulario en blanco o precargado) como en POST cuando la
    validación falla (para volver a mostrar el formulario con el
    error y sin perder lo que el usuario ya había escrito).

    Cada campo usa este patrón para quedar "sticky" en los dos casos:
      ${not empty propiedad ? propiedad.xxx : param.xxx}
    - modo edición / reintento tras error con objeto reconstruido:
      lee de ${propiedad}
    - reintento tras error de validación temprana (sin objeto):
      lee de ${param.xxx}, el valor crudo que el usuario ya había escrito
--%>

<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>
        <c:choose>
            <c:when test="${not empty propiedad}">Editar propiedad</c:when>
            <c:otherwise>Publicar propiedad</c:otherwise>
        </c:choose>
        — Inmobiliaria
    </title>

    <link href="https://fonts.googleapis.com/css2?family=Bricolage+Grotesque:opsz,wght@12..96,400..800&family=Karla:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
          crossorigin="anonymous">

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
</head>

<body>

<%@ include file="/WEB-INF/includes/navbar.jspf" %>

<main class="container my-5" style="max-width: 820px;">

    <h1 class="fuente-display mb-4">
        <c:choose>
            <c:when test="${not empty propiedad}">Editar propiedad</c:when>
            <c:otherwise>Publicar propiedad</c:otherwise>
        </c:choose>
    </h1>

    <c:if test="${not empty error}">
        <div class="alert alert-warning" role="alert">${error}</div>
    </c:if>

    <c:if test="${not empty errores}">
        <div class="alert alert-danger" role="alert">
            <p class="mb-1 fw-bold">Revisa lo siguiente antes de guardar:</p>
            <ul class="mb-0">
                <c:forEach var="e" items="${errores}">
                    <li>${e}</li>
                </c:forEach>
            </ul>
        </div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/propiedades/formulario"
          enctype="multipart/form-data"
          class="tarjeta-prop p-4">

        <c:if test="${not empty propiedad}">
            <input type="hidden" name="idPropiedad" value="${propiedad.id}">
        </c:if>

        <div class="row g-3">

            <div class="col-12 col-md-6">
                <label class="form-label" for="codigo">Código comercial</label>
                <input type="text" class="form-control" id="codigo" name="codigo" required
                       maxlength="20"
                       value="${not empty propiedad ? propiedad.codigo : param.codigo}">
            </div>

            <div class="col-12 col-md-6">
                <label class="form-label" for="matriculaInmobiliaria">Matrícula inmobiliaria</label>
                <input type="text" class="form-control" id="matriculaInmobiliaria" name="matriculaInmobiliaria" required
                       maxlength="30"
                       value="${not empty propiedad ? propiedad.matriculaInmobiliaria : param.matriculaInmobiliaria}">
            </div>

            <div class="col-12">
                <label class="form-label" for="titulo">Título</label>
                <input type="text" class="form-control" id="titulo" name="titulo" required
                       maxlength="150"
                       value="${not empty propiedad ? propiedad.titulo : param.titulo}">
            </div>

            <div class="col-12">
                <label class="form-label" for="descripcion">Descripción</label>
                <textarea class="form-control" id="descripcion" name="descripcion" rows="3"
                          >${not empty propiedad ? propiedad.descripcion : param.descripcion}</textarea>
            </div>

            <div class="col-12 col-md-4">
                <label class="form-label" for="operacion">Operación</label>
                <select class="form-select" id="operacion" name="operacion" required>
                    <option value="">Selecciona...</option>
                    <option value="ARRIENDO"
                        ${(not empty propiedad and propiedad.operacion == 'ARRIENDO')
                          or param.operacion == 'ARRIENDO' ? 'selected' : ''}>Arriendo</option>
                    <option value="VENTA"
                        ${(not empty propiedad and propiedad.operacion == 'VENTA')
                          or param.operacion == 'VENTA' ? 'selected' : ''}>Venta</option>
                </select>
            </div>

            <div class="col-12 col-md-4">
                <label class="form-label" for="estado">Estado</label>
                <select class="form-select" id="estado" name="estado">
                    <option value="BORRADOR"
                        ${(not empty propiedad and propiedad.estado == 'BORRADOR')
                          or (empty propiedad and empty param.estado) ? 'selected' : ''}>Borrador</option>
                    <option value="PUBLICADA"
                        ${(not empty propiedad and propiedad.estado == 'PUBLICADA') or param.estado == 'PUBLICADA' ? 'selected' : ''}>Publicada</option>
                    <option value="RESERVADA"
                        ${(not empty propiedad and propiedad.estado == 'RESERVADA') or param.estado == 'RESERVADA' ? 'selected' : ''}>Reservada</option>
                    <option value="CERRADA"
                        ${(not empty propiedad and propiedad.estado == 'CERRADA') or param.estado == 'CERRADA' ? 'selected' : ''}>Cerrada</option>
                </select>
            </div>

            <div class="col-12 col-md-4">
                <label class="form-label" for="idTipoPropiedad">Tipo de inmueble</label>
                <select class="form-select" id="idTipoPropiedad" name="idTipoPropiedad" required>
                    <option value="">Selecciona...</option>
                    <c:forEach var="t" items="${tiposPropiedad}">
                        <option value="${t.id}"
                            ${(not empty propiedad and propiedad.tipoPropiedadId == t.id)
                              or param.idTipoPropiedad == t.id ? 'selected' : ''}>
                            ${t.nombre}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="col-12 col-md-6">
                <label class="form-label" for="idCiudad">Ciudad</label>
                <select class="form-select" id="idCiudad" name="idCiudad" required>
                    <option value="">Selecciona...</option>
                    <c:forEach var="c" items="${ciudades}">
                        <option value="${c.id}"
                            ${(not empty propiedad and propiedad.ciudadId == c.id)
                              or param.idCiudad == c.id ? 'selected' : ''}>
                            ${c.nombre}, ${c.departamento}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="col-12 col-md-6">
                <label class="form-label" for="idInmobiliaria">Publicada por</label>
                <select class="form-select" id="idInmobiliaria" name="idInmobiliaria" required>
                    <option value="">Selecciona...</option>
                    <c:forEach var="i" items="${inmobiliarias}">
                        <option value="${i.id}"
                            ${(not empty propiedad and propiedad.inmobiliariaId == i.id)
                              or param.idInmobiliaria == i.id ? 'selected' : ''}>
                            ${i.nombreComercial}
                        </option>
                    </c:forEach>
                </select>
                <div class="form-text">
                    Temporal: hasta que el login esté integrado, se elige aquí manualmente
                    la agencia que publica.
                </div>
            </div>

            <div class="col-12 col-md-4">
                <label class="form-label" for="precio">Precio</label>
                <input type="number" class="form-control" id="precio" name="precio" required
                       min="0" step="1000"
                       value="${not empty propiedad ? propiedad.precio : param.precio}">
            </div>

            <div class="col-12 col-md-4">
                <label class="form-label" for="administracion">Administración</label>
                <input type="number" class="form-control" id="administracion" name="administracion"
                       min="0" step="1000"
                       value="${not empty propiedad ? propiedad.administracion : param.administracion}">
            </div>

            <div class="col-12 col-md-4">
                <label class="form-label" for="estrato">Estrato</label>
                <input type="number" class="form-control" id="estrato" name="estrato"
                       min="1" max="6"
                       value="${not empty propiedad ? propiedad.estrato : param.estrato}">
            </div>

            <div class="col-12 col-md-3">
                <label class="form-label" for="habitaciones">Habitaciones</label>
                <input type="number" class="form-control" id="habitaciones" name="habitaciones"
                       min="0"
                       value="${not empty propiedad ? propiedad.habitaciones : param.habitaciones}">
            </div>

            <div class="col-12 col-md-3">
                <label class="form-label" for="banos">Baños</label>
                <input type="number" class="form-control" id="banos" name="banos"
                       min="0"
                       value="${not empty propiedad ? propiedad.banos : param.banos}">
            </div>

            <div class="col-12 col-md-3">
                <label class="form-label" for="parqueaderos">Parqueaderos</label>
                <input type="number" class="form-control" id="parqueaderos" name="parqueaderos"
                       min="0"
                       value="${not empty propiedad ? propiedad.parqueaderos : param.parqueaderos}">
            </div>

            <div class="col-12 col-md-3">
                <label class="form-label" for="antiguedadAnios">Antigüedad (años)</label>
                <input type="number" class="form-control" id="antiguedadAnios" name="antiguedadAnios"
                       min="0"
                       value="${not empty propiedad ? propiedad.antiguedadAnios : param.antiguedadAnios}">
            </div>

            <div class="col-12 col-md-6">
                <label class="form-label" for="areaConstruida">Área construida (m²)</label>
                <input type="number" class="form-control" id="areaConstruida" name="areaConstruida"
                       min="0" step="0.01"
                       value="${not empty propiedad ? propiedad.areaConstruida : param.areaConstruida}">
            </div>

            <div class="col-12 col-md-6">
                <label class="form-label" for="areaLote">Área de lote (m²)</label>
                <input type="number" class="form-control" id="areaLote" name="areaLote"
                       min="0" step="0.01"
                       value="${not empty propiedad ? propiedad.areaLote : param.areaLote}">
            </div>

            <div class="col-12">
                <label class="form-label" for="direccion">Dirección</label>
                <input type="text" class="form-control" id="direccion" name="direccion" required
                       maxlength="180"
                       value="${not empty propiedad ? propiedad.direccion : param.direccion}">
            </div>

            <div class="col-12 col-md-6">
                <label class="form-label" for="barrio">Barrio</label>
                <input type="text" class="form-control" id="barrio" name="barrio"
                       maxlength="100"
                       value="${not empty propiedad ? propiedad.barrio : param.barrio}">
            </div>

        </div>

        <%-- ---------- Características ---------- --%>
        <c:if test="${not empty todasLasCaracteristicas}">
            <hr class="my-4">
            <h2 class="h5 mb-3">Características</h2>

            <c:forEach var="categoria" items="${categoriasCaracteristica}">

                <c:set var="hayEnCategoria" value="false"/>
                <c:forEach var="car" items="${todasLasCaracteristicas}">
                    <c:if test="${car.categoria == categoria}"><c:set var="hayEnCategoria" value="true"/></c:if>
                </c:forEach>

                <c:if test="${hayEnCategoria}">
                    <p class="fw-bold mb-2" style="font-size: 0.85rem; color: var(--gris); text-transform: uppercase; letter-spacing: 0.03em;">
                        <c:choose>
                            <c:when test="${categoria == 'INTERIOR'}">Interior</c:when>
                            <c:when test="${categoria == 'EXTERIOR'}">Exterior</c:when>
                            <c:when test="${categoria == 'CONJUNTO'}">Conjunto</c:when>
                            <c:otherwise>Seguridad</c:otherwise>
                        </c:choose>
                    </p>
                    <div class="row row-cols-2 row-cols-md-3 g-2 mb-3">
                        <c:forEach var="car" items="${todasLasCaracteristicas}">
                            <c:if test="${car.categoria == categoria}">
                                <div class="col">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox"
                                               name="idsCaracteristica" value="${car.id}"
                                               id="car${car.id}"
                                               ${caracteristicasAsignadas.contains(car.id) ? 'checked' : ''}>
                                        <label class="form-check-label" for="car${car.id}">
                                            ${car.nombre}
                                        </label>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </c:if>
            </c:forEach>
        </c:if>

        <%-- ---------- Imágenes ---------- --%>
        <hr class="my-4">
        <h2 class="h5 mb-3">Fotos</h2>

        <c:if test="${not empty imagenesActuales}">
            <p class="mb-2" style="font-size: 0.9rem; color: var(--gris);">
                Marca la foto que quieres como portada. Para quitar una foto, marca "Eliminar" y guarda.
            </p>
            <div class="row g-3 mb-3">
                <c:forEach var="img" items="${imagenesActuales}">
                    <div class="col-6 col-md-4 col-lg-3">
                        <div class="border rounded p-2" style="border-color: var(--borde) !important;">
                            <img src="${pageContext.request.contextPath}/${img.ruta}"
                                 alt="${img.textoAlt}"
                                 class="w-100 rounded mb-2"
                                 style="aspect-ratio: 4/3; object-fit: cover;">
                            <div class="form-check" style="font-size: 0.85rem;">
                                <input class="form-check-input" type="radio" name="imagenPortada"
                                       value="${img.id}" id="portada${img.id}"
                                       ${img.esPortada ? 'checked' : ''}>
                                <label class="form-check-label" for="portada${img.id}">Portada</label>
                            </div>
                            <div class="form-check" style="font-size: 0.85rem;">
                                <input class="form-check-input" type="checkbox" name="eliminarImagen"
                                       value="${img.id}" id="eliminar${img.id}">
                                <label class="form-check-label text-danger" for="eliminar${img.id}">Eliminar</label>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <label class="form-label" for="imagenesNuevas">Agregar fotos nuevas</label>
        <input type="file" class="form-control" id="imagenesNuevas" name="imagenesNuevas"
               accept="image/png, image/jpeg, image/webp" multiple>
        <div class="form-text">
            JPG, PNG o WEBP, máximo 5 MB por foto. Puedes seleccionar varias a la vez.
        </div>

        <div class="d-flex gap-2 mt-4">
            <button type="submit" class="btn btn-marca">Guardar</button>
            <a href="${pageContext.request.contextPath}/propiedades" class="btn btn-contorno"
               style="color: var(--tinta); border-color: var(--borde);">Cancelar</a>
        </div>

    </form>

</main>

<%@ include file="/WEB-INF/includes/footer.jspf" %>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>

</body>
</html>
