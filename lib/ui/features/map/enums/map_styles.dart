enum MapStyles {
  street(
    "Street",
    '''{
         "version": 8,
         "sources": {
           "OSM": {
             "type": "raster",
             "tiles": [
               "https://a.tile.openstreetmap.org/{z}/{x}/{y}.png",
               "https://b.tile.openstreetmap.org/{z}/{x}/{y}.png",
               "https://c.tile.openstreetmap.org/{z}/{x}/{y}.png"
             ],
             "tileSize": 256,
             "attribution": "© OpenStreetMap contributors",
             "maxzoom": 24
           }
         },
         "layers": [
           {
             "id": "OSM-layer",
             "source": "OSM",
             "type": "raster"
           }
         ]
       }''',
    "assets/icon/street_layer.jpg",
  ),
  satellite(
    "Satellite",
    '''{
         "version": 8,
         "sources": {
           "satellite": {
             "type": "raster",
             "tiles": [
          "https://mt1.google.com/vt/lyrs=y&x={x}&y={y}&z={z}"
             ],
             "tileSize": 256,
             "attribution": "© OpenStreetMap contributors",
             "maxzoom": 24
           } 
         },
         "layers": [
           {
             "id": "satellite-layer",
             "type": "raster",
             "source": "satellite",
             "layout": {
               "visibility": "visible"
             }
           }
         ]
       }
       ''',
    "assets/icon/satellite_layer.jpg",
  ),
  light(
    "Light",
    "https://tiles.basemaps.cartocdn.com/gl/positron-gl-style/style.json",
    "assets/icon/default_layer.jpg",
  ),
  dark(
    "Dark",
    "https://tiles.basemaps.cartocdn.com/gl/dark-matter-gl-style/style.json",
    "assets/icon/dark_layer.jpg",
  );

  final String label;
  final String styleString;
  final String image;

  const MapStyles(
    this.label,
    this.styleString,
    this.image,
  );
}
