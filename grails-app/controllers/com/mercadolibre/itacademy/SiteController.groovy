package com.mercadolibre.itacademy

import grails.converters.JSON
import groovy.json.JsonSlurper
class SiteController {
    def index() {
        def url = new URL("http://localhost:8090/marcas")
        def connection = (HttpURLConnection) url.openConnection()
        connection.setRequestMethod("GET")
        connection.setRequestProperty("Accept", "application/json")
        connection.setRequestProperty("User-Agent", "Mozilla/5.0")
        JsonSlurper json = new JsonSlurper()
        def sites = json.parse(connection.getInputStream())
        [sites:sites]
    }
    def categorias(String id) {
        def url = new URL("http://localhost:8090/marcas/"+id+"/articulos")
        def connection = (HttpURLConnection) url.openConnection()
        connection.setRequestMethod("GET")
        connection.setRequestProperty("Accept", "application/json")
        connection.setRequestProperty("User-Agent", "Mozilla/5.0")
        JsonSlurper json = new JsonSlurper()
        def categories = json.parse(connection.getInputStream())
        def respuesta = [categories:categories]

        render respuesta as JSON
    }
    def subcategorias(String id){
        def url = new URL("http://localhost:8090/articulos/"+id)
        def connection = (HttpURLConnection) url.openConnection()
        connection.setRequestMethod("GET")
        connection.setRequestProperty("Accept", "application/json")
        connection.setRequestProperty("User-Agent", "Mozilla/5.0")
        JsonSlurper json = new JsonSlurper()
        def categories = json.parse(connection.getInputStream())
        def respuesta = [categories:categories]
        render respuesta as JSON
    }
    def deleteElement(String id) {
        def url = new URL("http://localhost:8090/articulos/" + id)
        def connection = (HttpURLConnection) url.openConnection()
        connection.setRequestMethod("DELETE")
        connection.setRequestProperty("Accept", "application/json")
        connection.setRequestProperty("User-Agent", "Mozilla/5.0")
        connection.getInputStream()
        def respuesta = [statuscode: 204]
        render respuesta as JSON
    }
}