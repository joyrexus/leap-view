# leap-view

Render [leap motion](https://www.leapmotion.com) gesture samples recorded with the [leap-record](https://github.com/joyrexus/leap-record) utility.

The inline viewer ([index.html](index.html)) provides ...

* [simple playback controls](https://github.com/joyrexus/leap-view/blob/master/docs/overview.md#playback-controls)

* [extraction of motion data within user specified time ranges](https://github.com/joyrexus/leap-view/blob/master/docs/overview.md#extracting-positionvelocity-data)

---

![screenshot](screenshot.png)

---

See [data](https://github.com/joyrexus/leap-view/tree/master/data) for a sample data file.  Try loading this sample in our [demo viewer](http://joyrexus.github.io/sgm/tohf/index.html) page for a quick preview of how things work.

See [docs/overview](https://github.com/joyrexus/leap-view/blob/master/docs/overview.md) for a step-by-step walkthrough of the process of capturing and
extracting gesture data.  Note that you can [customize](https://github.com/joyrexus/leap-view/blob/master/docs/overview.md#customizing-the-motion-data-to-be-extracted) the motion data that the viewer will extract and download.


## Warning!

The viewer was designed for an internal project and presented here to
demonstrate a few basic techniques for rendering leap motion samples captured
with our [leap-record](https://github.com/joyrexus/leap-record).  It's only been tested in Chrome and no effort has been made to make it cross-browser friendly.  Many of the viewer's playback and extraction features are Webkit specific.
