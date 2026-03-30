praznistanovi.html iz a site that allows people to report empty dwellings. Inspired by the Soviet union and @https://hr.wikipedia.org/wiki/Pavlik_Morozov
The style of the site should be in the style of the Soviet union.

The site is a simple html+css+js, no frontend frameworks. The main page is praznistanovi.html.

The main page is simple, it has a title, a description, and a button to upload a photo. It also has some statistics. The first is a big number Total Apartments reported, Then below two columns. One column shows a leaderboard of the top 5 users by points. The other column shows a leaderboard of top 5 cities by number of empty apartments. The stats are in praznistanovi.json.

Title of the page is "Prazne stanove".
Description of the page is "Vlada RH ima saznanja da, u ovo vrijeme sve manje priustivosti, u nasim gradovima postoji 600.000 praznih stanova. Skriveni su posvuda. Pomozite nam da ih otkrijemo. Lista ce biti dostavljena vlastima na daljnje postupanje. Najbolje prijavljivace cekaju ordeni i brojne nagrade.
The button to upload a photo is called "Posalji fotografiju".

It allows users to upload images of buildings by night, and the site will then recognize which apartments are empty by looking at windows that are dark. (To confirm apartments are empty the same building has to be photographed 3 times? For version one, work on just one photo.)

There is an upload button, which allows the user to choose a photo from their device and upload it to the site. Once uploaded the photo is displayed on the screen in a modal window of fixed size (photo is resized to fit the window).

Modal is called "Prepoznaj prazne stanove". All the windows in the building are clickable, and when clicked once the window gets a green checkmark which means it is empty. When clicked again the window is "unchecked". User is able to click anywhere, when they do we try to determine if it's a window. A lit window will be a patch of light surrounded by darker areas. A dark window will be a patch of dark surrounded by lighter areas. The check for this will be simple and work in frontend js.

The user must also choose the city of the building.

When the user is happy with the result, the user can click a button to submit the result to the server. The server will then save the result to the database (in the first version, no saving, just display a summary of the results). The user will get 1 point for each empty apartment.

TODO:

Advanced ideas for V2 (gnore for now):
We build and auto-processing function. The processing function will use AI in the future, but for now we will have a simple algorithm that will recognize empty apartments by looking at windows that are dark. Steps:

1. make the photo black and white
2. find windows by detecting edges in the photo
3. for each window, check if it is dark

Fix the croatian diacritics in the text.
Populate the deploy-to-server.sh to be a deploy script which wll deploy the site to the sshkrpa
sshkrpa='ssh root@207.154.200.141 -i ~/.ssh/id_ed25519'
/var/www/krpa.me

The site should be at https://krpa.me/praznistanovi/
Do I need to do any nginx configuration?

Ovo je rana verzija, nemojte jos siriti okolo, jer, znajuci kakvih ljudi ima, moram prvo kupiti jaci server. Puno jaci...
