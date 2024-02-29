# mcap-to-mp4

A tool to convert ROS topics recored with [mcap](https://mcap.dev/) to MP4 file

## Requirements

* ffmpeg

## QuickStart

```
docker build -t tiryoh/mcap-to-mp4 .
```

```
docker run --rm -it -v "$(PWD):/works" tiryoh/mcap-to-mp4
```

```
usage: mcap-to-mp4
[-h]
[-t TOPIC]
[-o OUTPUT]
[-c {rgb,bgr,rgba,bgra}]
input

positional arguments:
  input
    input bag file path to read

options:
  -h, --help
    show this help message and exit
  -t TOPIC, --topic TOPIC
    topic name to convert. if not specified, the topic list will be shown
  -o OUTPUT, --output OUTPUT
    output file name
  -c {rgb,bgr,rgba,bgra}, --channel_order {rgb,bgr,rgba,bgra}
    channel order
```


## License

MIT License

 Copyright 2024 Daisuke Sato
