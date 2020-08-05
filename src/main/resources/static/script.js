function initialize() {
    getAnime("/api/anime");
    renderModal("createAnime", "modals");
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

function getOneAnime(id) {
    var url = "/api/anime/" + id;
    //make initial api call to get Student list
    var xhttpList = new XMLHttpRequest();
    var anime;

    // Read JSON - and put in storage
    xhttpList.onreadystatechange = function () {

        if (this.readyState == 4 && this.status == 200) {
            sessionStorage.setItem("anime", this.responseText);
        }
    };
    xhttpList.open("GET", url, false);
    xhttpList.send();
    console.log("Single anime retrieved");

    return sessionStorage.getItem("anime");
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
        + '<div id="update' + json[i].id + '">'
        + '<button type="button" class="btn btn-danger" onclick="deleteAnime('+ json[i].id + ')">Delete</button>'
        + '</div>'
        + '</td>'
        + '</tr>';

        document.getElementById("anime").insertAdjacentHTML("beforeend", tableHtml);
        
        renderModal("updateAnime", json[i].id);
    }
}

function renderModal(modalPurpose, id) {

    var location;
    var color;
    var btntxt;
    var anime;
    var animeID = '';
    var title;

    switch (modalPurpose) {
        case "createAnime":
            location = id;
            color = "btn-primary";
            btntxt = "Add";
            title = "Add Anime";
            break;
        case "updateAnime":
            anime = getOneAnime(id);
            animeID = JSON.parse(anime).id;
            location = "update" + id;
            color = "btn-warning";
            btntxt = "Edit";
            title = "Update Anime";
            break;
    }

    var buttonHtml = '<button type="button" class="btn ' + color + '" data-toggle="modal" data-target="#' + modalPurpose + animeID + '">' + btntxt + '</button>';
    document.getElementById(location).insertAdjacentHTML('beforeend', buttonHtml);

    var modalHtml = ' <div class="modal fade" id="' + modalPurpose + animeID + '"> '
        + ' <div class="modal-dialog modal-xl"> '
        + ' <div class="modal-content"> '

        + '<div class="modal-header">'
        + '<h4 class="modal-title title">' + title + '</h4>'
        + '<button type="button" class="close" data-dismiss="modal">&times;</button>'
        + '</div>'

        + '<div class="modal-body">'
        + animeForm(anime, modalPurpose)
        + '</div>'

        + '<div class="modal-footer">'
        + '<button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>'
        + '</div>'

        + '</div>'
        + '</div>'
        + '</div>'
        + '</div>';

    document.getElementById("modals").insertAdjacentHTML('beforeend', modalHtml);

}

function createAnime() {

    var sendData = {
        "name": document.getElementById("createAnimename").value,
        "releaseDate": document.getElementById("createAnimereleaseDate").value,
        "showImage": document.getElementById("createAnimeshowImage").value,
        "description": document.getElementById("createAnimedescription").value,
        "rating": document.getElementById("createAnimerating").value,
        "creator": document.getElementById("createAnimecreator").value,
        "creatorImage": document.getElementById("createAnimecreatorImage").value,
        "protagonist": document.getElementById("createAnimeprotagonist").value,
        "protagImage": document.getElementById("createAnimeprotagImage").value
    }
    console.log(sendData);

    // Confirmation about creating
    var ok = confirm("Are you sure you want to add this Anime?");

    if (ok == true) {
        var xhttp = new XMLHttpRequest();
        xhttp.open("POST", "/api/add/anime", true);
        xhttp.setRequestHeader('Content-Type', 'application/json');
        xhttp.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                console.log("Update success");
                var display = document.getElementById("anime");
                display.innerHTML = '';
                getAnime("/api/anime");
                console.log("Anime created!");
            }
        };
        xhttp.send(JSON.stringify(sendData));
    }

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

function updateAnime(id) {

    var sendData = {
        "id": id,
        "name": document.getElementById("updateAnimename"+id).value,
        "releaseDate": document.getElementById("updateAnimereleaseDate"+id).value,
        "showImage": document.getElementById("updateAnimeshowImage"+id).value,
        "description": document.getElementById("updateAnimedescription"+id).value,
        "rating": document.getElementById("updateAnimerating"+id).value,
        "creator": document.getElementById("updateAnimecreator"+id).value,
        "creatorImage": document.getElementById("updateAnimecreatorImage"+id).value,
        "protagonist": document.getElementById("updateAnimeprotagonist"+id).value,
        "protagImage": document.getElementById("updateAnimeprotagImage"+id).value
    }
    console.log(sendData);

    var ok = confirm("Are you sure you want to appl these changes?");

    if (ok == true) {
        var xhttp = new XMLHttpRequest();
        xhttp.open("PUT", "/api/update/anime", true);
        xhttp.setRequestHeader('content-Type', 'application/json');
        xhttp.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
                console.log("Update success");
                var display = document.getElementById("anime");
                display.innerHTML = '';
                getAnime("/api/anime");
            }
        };
        
        xhttp.send(JSON.stringify(sendData));
    }
}

function animeForm(anime, purpose) {
    
    var input;
    var id;
    var name;
    var releaseDate;
    var showImage;
    var description;
    var rating;
    var creator;
    var creatorImage;
    var protagonist;
    var protagImage;
    var action;

    switch (purpose) {
        case "createAnime":
            input = '';
            id ='';
            name = '';
            releaseDate = '';
            showImage = '';
            description = '';
            rating = '';
            creator = '';
            creatorImage = '';
            protagonist = '';
            protagImage = '';
            action = 'createAnime()';
            break;
        case "updateAnime":
            input = JSON.parse(anime);
            id = input.id;
            name = input.name;
            releaseDate = input.releaseDate;
            showImage = input.showImage;
            description = input.description;
            rating = input.rating;
            creator = input.creator;
            creatorImage = input.creatorImage;
            protagonist = input.protagonist;
            protagImage = input.protagImage;
            action = 'updateAnime(' + input.id + ')';
            break;
    }

    var form = ''
        + '<form>'
        + '<div class="form-group">'
        + '<label for="name">Anime Name:</label>'
        + '<input type="text" class="form-control" placeholder="Enter name of anime" id="' + purpose + 'name' + id +'" value="' + name + '">'
        + '</div>'
        + '<div class="form-group">'
        + '<label for="show">Show Image:</label>'
        + '<input type="url" class="form-control" placeholder="Enter image url" id="' + purpose + 'showImage' + id +'" value="' + showImage + '">'
        + '</div>'
        + '<div class="form-group">'
        + '<label for="description">Description:</label>'
        + '<input type="text" class="form-control" placeholder="Enter description for anime" id="' + purpose + 'description' + id +'" value="' + description + '">'
        + '</div>'
        + '<div class="form-group">'
        + '<label for="rating">Rating:</label>'
        + '<input type="number" class="form-control" placeholder="Enter a rating on a scale of 1-10" id="' + purpose + 'rating' + id +'" value="' + rating + '" min="1" max="10">'
        + '</div>'
        + '<div class="form-group">'
        + '<label for="main">Main Character:</label>'
        + '<input type="text" class="form-control" placeholder="Enter name of main character" id="' + purpose + 'protagonist' + id +'" value="' + protagonist + '">'
        + '</div>'
        + '<div class="form-group">'
        + '<label for="mainImage">Main Character Image:</label>'
        + '<input type="url" class="form-control" placeholder="Enter image url" id="' + purpose + 'protagImage' + id +'" value="' + protagImage + '">'
        + '</div>'
        + '<div class="form-group">'
        + '<label for="date">Release Date:</label>'
        + '<input type="date" class="form-control" id="' + purpose + 'releaseDate' + id +'" value="' + releaseDate + '">'
        + '</div>'
        + '<div class="form-group">'
        + '<label for="creator">Creator/Writer:</label>'
        + '<input type="text" class="form-control" placeholder="Enter name of creator/writer" id="' + purpose + 'creator' + id +'" value="' + creator + '">'
        + '</div>'
        + '<div class="form-group">'
        + '<label for="creatorImage">Creator/Writer Image:</label>'
        + '<input type="url" class="form-control" placeholder="Enter image url" id="' + purpose + 'creatorImage' + id +'" value="' + creatorImage + '">'
        + '</div>'
        + '<button type="submit" class="btn btn-success" data-dismiss="modal" onclick="' + action + '">Submit</button>'
        + '</form>'
        
    return form;
}