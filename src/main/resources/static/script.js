function initialize() {
    getAnime("/api/anime");
    renderAddModal("createAnime");
    renderUpdateModal("updateAnime");
    //addAnime("/api/add/anime");
}

function getAnime(url) {

    var xhttpList = new XMLHttpRequest();

    xhttpList.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            renderAnime(this.responseText);
        }
    };
    xhttpList.open("GET", url, true);
    xhttpList.send();
    console.log("Anime List Received!!");
}

function renderAnime(data) {

    var json = JSON.parse(data);

    for(var i = 0; i < json.length; i++){

        var tableHtml = '<tr id="' + json[i].id + '">'
        + '<td><img src=' + json[i].showImage + ' alt="Add Image" class="tableImg"><br>' + json[i].name + '</td>'
        + '<td class="desc">' + json[i].description + '</td>'
        + '<td>' + json[i].rating + '</td>'
        + '<td><img src=' + json[i].protagImage + ' alt="Add Image" class="tableImg"><br>' + json[i].protagonist + '</td>'
        + '<td>' + json[i].releaseDate + '</td>'
        + '<td><img src=' + json[i].creatorImage + ' alt="Add Image" class="tableImg"><br>' + json[i].creator + '</td>'
        + '<td><br>'
        + '<br>'
        + '<button type="button" class="btn btn-danger" onclick="deleteAnime('+ json[i].id + ')">Delete</button>'
        + '</td>'
        + '</tr>';

        document.getElementById("anime").insertAdjacentHTML("beforeend", tableHtml);
        
    }
}

function renderAddModal(modalPurpose) {

    var modalHTML = '<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#'+ modalPurpose +'">Add</button>'
    + ' <div class="modal fade" id="' + modalPurpose + '"> '
    + ' <div class="modal-dialog modal-xl"> '
    + ' <div class="modal-content"> '

    + '<div class="modal-header">'
    + '<h4 class="modal-title title">Add New Anime</h4>'
    + '<button type="button" class="close" data-dismiss="modal">&times;</button>'
    + '</div>'

    + '<div class="modal-body">'
    + '<form action="table.html" onsubmit="addAnime()">'
    + '<div class="form-group">'
    + '<label for="name">Anime Name:</label>'
    + '<input type="text" class="form-control" placeholder="Enter name of anime" id="name" required>'
    + '</div>'
    + '<div class="form-group">'
    + '<label for="show">Show Image:</label>'
    + '<input type="url" class="form-control" placeholder="Enter a image url" id="show">'
    + '</div>'
    + '<div class="form-group">'
    + '<label for="description">Description:</label>'
    + '<input type="text" class="form-control" placeholder="Enter description for anime" id="description">'
    + '</div>'
    + '<div class="form-group">'
    + '<label for="rating">Rating:</label>'
    + '<input type="number" class="form-control" placeholder="Enter a rating on a scale of 1-10" id="rating" min="1" max="10">'
    + '</div>'
    + '<div class="form-group">'
    + '<label for="main">Main Character:</label>'
    + '<input type="text" class="form-control" placeholder="Enter name of main character" id="main">'
    + '</div>'
    + '<div class="form-group">'
    + '<label for="mainImage">Main Character Image:</label>'
    + '<input type="url" class="form-control" placeholder="Enter a image url" id="mainImage">'
    + '</div>'
    + '<div class="form-group">'
    + '<label for="date">Release Date:</label>'
    + '<input type="date" class="form-control" id="date">'
    + '</div>'
    + '<div class="form-group">'
    + '<label for="creator">Creator/Writer:</label>'
    + '<input type="text" class="form-control" placeholder="Enter name of creator/writer" id="creator">'
    + '</div>'
    + '<div class="form-group">'
    + '<label for="creatorImage">Creator/Writer Image:</label>'
    + '<input type="url" class="form-control" placeholder="Enter a image url" id="creatorImage">'
    + '</div>'
    + '<button type="submit" class="btn btn-success">Submit</button>'
    + '</form>'
    + '</div>'

    + '<div class="modal-footer">'
    + '<button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>'
    + '</div>'

    + '</div>'
    + '</div>'
    + '</div>'
    + '</div>';

    document.getElementById("modals").insertAdjacentHTML("beforeend", modalHTML);

}

function renderUpdateModal(modalPurpose) {

    var modalHTML = '<button type="button" class="btn btn-warning alignment" data-toggle="modal" data-target="#'+ modalPurpose +'">Update</button>'
    + ' <div class="modal fade" id="' + modalPurpose + '"> '
    + ' <div class="modal-dialog modal-xl"> '
    + ' <div class="modal-content"> '

    + '<div class="modal-header">'
    + '<h4 class="modal-title title">Update Anime</h4>'
    + '<button type="button" class="close" data-dismiss="modal">&times;</button>'
    + '</div>'

    + '<div class="modal-body">'
    + '</div>'

    + '<div class="modal-footer">'
    + '<button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>'
    + '</div>'

    + '</div>'
    + '</div>'
    + '</div>'
    + '</div>';

    document.getElementById("modals").insertAdjacentHTML("beforeend", modalHTML);

}

function deleteAnime(id) {

    var link = "/api/delete/anime/" + id;

    var ok = confirm("Are you sure you want to delete this anime?\nPress 'ok' to continue, or 'cancel' to cancel");

    if(ok == true){
        var xhttp = new XMLHttpRequest();
        xhttp.open("DELETE", link, true);

        xhttp.onreadystatechange = function() {
            if(this.readyState == 4 && this.status == 200){
                var removeCard = document.getElementById(id);

                removeCard.parentNode.removeChild(removeCard);
                console.log("Anime deleted");
            }
        };
        xhttp.send(null);
    }

}

// function addAnime(url) {

//     var xhttp = new XMLHttpRequest();

//     xhttp.onreadystatechange = function() {
//         if(this.readyState == 4 && this.status == 200){
//             var data = {
//                 name: document.getElementById("name").value,
//                 releaseDate: document.getElementById("date").value,
//                 showImage: document.getElementById("show").value,
//                 description: document.getElementById("description").value,
//                 rating: document.getElementById("rating").value,
//                 creator: document.getElementById("creator").value,
//                 creatorImage: document.getElementById("creatorImage").value,
//                 protagonist: document.getElementById("main").value,
//                 protagImage: document.getElementById("mainImage").value
//             }

//             renderAnime(data);
//         }
//     };
//     xhttp.open("POST", url, true);
//     xhttp.send();
// }