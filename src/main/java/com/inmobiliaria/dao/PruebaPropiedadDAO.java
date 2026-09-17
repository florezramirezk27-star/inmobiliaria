package com.inmobiliaria.dao;

import com.inmobiliaria.model.Operacion;
import com.inmobiliaria.model.Propiedad;

import java.math.BigDecimal;
import java.util.List;

/**
 * Prueba manual de PropiedadDAO contra la base local.
 *
 * Sigue el mismo estilo de DatabaseTest: se ejecuta con main() para
 * comprobar rápidamente que el DAO habla bien con MySQL, antes de montar
 * el servlet. No es una prueba de JUnit porque necesita la base cargada
 * con database/ddl.sql y database/dml.sql.
 *
 * Ejecutar con:
 *     mvn compile
 *     mvn exec:java -Dexec.mainClass=com.inmobiliaria.dao.PruebaPropiedadDAO
 *
 * Resultado esperado con los datos de prueba (v2, 10 propiedades,
 * 9 publicadas — la BUC-0007/lote queda en BORRADOR):
 *     publicadas           -> 9
 *     arriendo             -> 5
 *     Bucaramanga          -> 6
 *     apartamentos         -> 2
 *     hasta 2.000.000      -> 3
 *     texto "provenza"     -> 1
 */
public class PruebaPropiedadDAO {

    public static void main(String[] args) {

        PropiedadDAO dao = new PropiedadDAO();

        try {
            // --- 1. Catálogo completo ---
            List<Propiedad> recientes = dao.listarRecientes(20);
            System.out.println("Publicadas: " + recientes.size());
            for (Propiedad p : recientes) {
                System.out.printf("  %-9s %-40s %14s %s%n",
                        p.getCodigo(),
                        p.getTitulo(),
                        p.getPrecio(),
                        p.getUbicacionCorta());
            }

            // --- 2. Filtro por operación ---
            FiltroPropiedad soloArriendo = new FiltroPropiedad();
            soloArriendo.setOperacion(Operacion.ARRIENDO);
            System.out.println("\nEn arriendo: " + dao.contar(soloArriendo));

            // --- 3. Filtro por ciudad ---
            FiltroPropiedad enBucaramanga = new FiltroPropiedad();
            enBucaramanga.setCiudadId(1);
            System.out.println("En Bucaramanga: " + dao.contar(enBucaramanga));

            // --- 4. Filtro por tipo ---
            FiltroPropiedad apartamentos = new FiltroPropiedad();
            apartamentos.setTipoSlug("apartamento");
            System.out.println("Apartamentos: " + dao.contar(apartamentos));

            // --- 5. Filtro por precio ---
            FiltroPropiedad economicas = new FiltroPropiedad();
            economicas.setPrecioMaximo(new BigDecimal("2000000"));
            System.out.println("Hasta $2.000.000: " + dao.contar(economicas));

            // --- 6. Búsqueda por texto ---
            FiltroPropiedad porTexto = new FiltroPropiedad();
            porTexto.setTexto("provenza");
            List<Propiedad> encontradas = dao.buscar(porTexto);
            System.out.println("Texto 'provenza': " + encontradas.size());
            for (Propiedad p : encontradas) {
                System.out.println("  " + p.getTitulo());
            }

            // --- 7. Ficha completa ---
            Propiedad ficha = dao.buscarPorId(1);
            if (ficha != null) {
                System.out.println("\nFicha id=1");
                System.out.println("  titulo:  " + ficha.getTitulo());
                System.out.println("  estado:  " + ficha.getEstado());
                System.out.println("  estrato: " + ficha.getEstrato());
                System.out.println("  mensual: " + ficha.isPrecioMensual());
                System.out.println("  portada: " + ficha.getRutaPortada());
            } else {
                System.out.println("\nNo se encontró la propiedad con id=1");
            }

            // --- 8. Campo NULL: el lote no tiene estrato ni área construida ---
            Propiedad lote = dao.buscarPorId(7);
            if (lote != null) {
                System.out.println("\nFicha id=7 (lote en borrador)");
                System.out.println("  estado:          " + lote.getEstado());
                System.out.println("  estrato:         " + lote.getEstrato());
                System.out.println("  area_construida: " + lote.getAreaConstruida());
            }

        } catch (Exception e) {
            System.err.println("Falló la prueba del DAO: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
