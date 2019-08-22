<!doctype html>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Welcome to Grails</title>
    <script src="https://unpkg.com/vue/dist/vue.min.js"></script>
    <script src="https://unpkg.com/axios/dist/axios.min.js"></script>
    <style>

        #title{
            color:#e0a800;
            text-align: center;
            font-size: 40px;
        }

        #select{
            font-size: 20px ;

        }
        .center{
            padding:15px;
            display: flex;
            align-content: center;
            justify-content: center;
            align-items: center;
            flex-wrap: wrap;
        }

        .list{

            width: 300px;
            padding: 10px 10px 20px;
            margin: 15px;
            margin-left: auto;
            margin-right: auto;
            border: 1px solid #f5f5f5;
            box-shadow: 0 0 10px rgba(0,0,0,.2);
            border-radius: 10px;
            background: #fff;
            list-style: none;
        }

        .li{
            font-size: 16px;
            padding: 10px 0;
            border-bottom: 1px solid #e0e0e0;
        }
        #history{
            font-size: 16px;
            font-weight: bold;
            padding:0;
            margin: 0;
        }
        label{
            font-weight: bold;
        }

    </style>
</head>
<body>

<div id="sites">
    <h1 id="title"> Sites</h1>

    <div class="center">
    <select id="select" onchange="sites.getCategories(this.value)">
        <option value="null">Selecionar</option>
        <g:each in="${sites}" var="site">
            <option id="${site?.id}" value="${site?.id}">${site?.name}</option>
        </g:each>
    </select>
    </div>
    <div class="center">
        <div id="history">

        </div>
    </div>
    <ul class="list">
        <li class="li li-item" v-for="category in categories">
            <a href="#" :id=category.id onclick="sites.getChildren(this.id)">{{category.name}}</a>
        </li>
    </ul>



    <!-- Modal -->
    <div id="mymodal" class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="titleModal">asdasdsa</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="imgModal"></div>
                    <p id="idModal"></p>
                    <p id="totalItemModal"></p>


                    <div class="editDiv" hidden>
                    <br>
                    <input type="text" id="editName">
                    <label for="editName">NAME </label>
                    <br>
                    <input type="text" id="editPicture">
                    <label for="editPicture">PICTURE </label>
                    <br>
                    <input type="number" id="editCantidad">
                    <label for="editCantidad">CANTIDAD </label>
                        <button id="boton-editar" type="button" class="btn btn-secondary" onclick="edit()">EDITAR</button>
                    </div>

                </div>

                <div class="modal-footer">
                    <button id="boton-edit" type="button" class="btn btn-secondary" onclick="edit()">MOSTRAR EDICIÓN</button>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal" onclick="sites.deleteElement()">DELETE</button>
                </div>
            </div>
        </div>
    </div>

</div>

<script>


    function edit(){
        document.getElementsByClassName("editDiv")[0].removeAttribute("Hidden")
    }

    var sites = new Vue({
        el:"#sites",
        data: {
            categories:[],
            subcategories:[],
            idActual:null
        },
        methods:{
            getCategories: function(strSite){
                var history = document.getElementById("history")
                var select = document.getElementById("select")
                var texto = select.options[select.selectedIndex].innerHTML;
                history.innerHTML= "" + texto

                axios.get('/site/categorias/',{
                    params:{
                        id:strSite
                    }
                }).then(function (response) {
                    console.log(response.data)
                    sites.categories = response.data.categories;
                }).catch(function (error) {
                    console.log(error)
                })
            },
            getChildren: function(strSite){
                var history = document.getElementById("history")
                var elem = document.getElementById(strSite).innerText
                //console.log(elem)
                //history.innerHTML= history.innerHTML + " > " + elem



                console.log("getChildren " + strSite)
                axios.get('/site/subcategorias/',{
                    params:{
                        id:strSite
                    }
                }).then(function (response) {

                    if(response.data.categories.children_categories.length == 0){
                        sites.idActual = response.data.categories.id;
                        $("#mymodal").modal("show");
                        $("#titleModal").html(response.data.categories.name)
                        $("#idModal").html("ID: " + response.data.categories.id)
                        $("#totalItemModal").html("TOTAL DE ELEMENTOS: " + response.data.categories.total_items_in_this_category)
                        $("#imgModal").html("<img src=" + response.data.categories.picture + ">" )


                        console.log("no hay bendiciones :)")

                    } else{
                        sites.categories = response.data.categories.children_categories;

                    }


                }).catch(function (error) {
                    console.log(error)
                })
            },
            deleteElement: function() {

                axios.get('/site/deleteElement/',{
                    params:{
                        id: sites.idActual
                    }
                }).then(function (response) {
                    console.log("Exelent")
                }).catch(function (error) {
                    console.log(error)
                })
            }
        }
    })
</script>
</body>
</html>