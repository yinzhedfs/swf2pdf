## SWF convert to PDF
#### The test environment is Ubuntu

* This `convert` is from Imagemagick,the binary is run in x86-64 platform,you can install others by `sudo apt install imagemagick` in Debian/Ubuntu,or you can install with `yum` in Fedora/Centos
* This `swfrender` is from swftools,you can download source package in [http://www.swftools.org/](http://www.swftools.org/)
* Put your swf files in `swfFiles`,and just run the shell script `$./convert.sh`,converted pdf files in `pdfFiles`,also you can modify the parameters in script by yourself.
