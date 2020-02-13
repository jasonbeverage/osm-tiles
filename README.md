# osm-tiles
Dockerfile for generating openstreetmap tiles

The goal of this dockerfile is to generate OpenStreetMap vector tiles to power osgEarth based applications.

You're going to need lots of ram to generate this tileset, at least 60GB.  So fire up something like an r4.2xlarge instance on AWS and allocate around 1TB of disk space for temporary data storage.

First, download the latest osm dataset.

You can get it from osm.org using
```
wget https://planet.osm.org/pbf/planet-latest.osm.pbf
```

Or, if you're on AWS you can get it from the osm-pds s3 repo much faster.

Install awscli
```
apt-get update && apt-get install awscli
```

Find the planet file you want to download
```
aws s3 ls osm-pds/2018/
```

The last pbf file is the most recent, so lets download it.
```
aws s3 cp s3://osm-pds/2018/planet-180226.osm.pbf planet-latest.osm.pbf
```


Filter out only the things we need
```
docker run -v $(pwd):/data jasonbeverage/osm-tiles osmium tags-filter /data/planet-latest.osm.pbf building landuse natural!=water surface amenity aeroway highway leisure man_made power railway -o /data/qa.pbf
```

Now generate the vector tiles.
```
docker run -it -v $(pwd):/data jasonbeverage/osm-tiles sh -c "osmium export -f geojsonseq --config=/qa.json /data/qa.pbf | tippecanoe -f -pf -pk -ps -Z14 -z14 -d12 --no-tile-stats -b0 -l osm -n osm-qa -o /data/osm-qa.mbtiles"
```

Grab some :coffee:

Your vector tiles are now available in the current directory at osm-qa.mbtiles



