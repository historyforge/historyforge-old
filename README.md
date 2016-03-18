# HistoryForge

This project is a fork of MapWarper (timwaters/mapwarper). Go there for setup instructions.
* Updates styles to Bootstrap 3
* Removes ability for public to upload maps, layers, comments, and other social stuff.
* Renames "mosaics" to map layers
* Uses cancan for authorization (WIP)
* Uses simple_form (WIP)
* Uses ransack for search (WIP)
* Adds buildings as a content type
* Adds 1910 census records as a content type
* Connects people to buildings
* Presents a searchable interface integrating map layers, buildings, and people.

It will eventually:
* Connect census records via people records
* Run on a supported version of Ruby (not 2.0.0) - waiting for ruby-mapscript to work with Ruby 2.2.x.

The intended use is for a local historical society to create a combination map library, building, resident, and photo database.


