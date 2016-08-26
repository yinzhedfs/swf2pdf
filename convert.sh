#/bin/bash
# by yinzhedfs

work_dir=`pwd`            # 工作目录
source_dir="swfFiles"     # swf文件存放目录
dest_dir="pdfFiles"       # 转换后的pdf存放目录
png_tmp_dir="tmp"         # swf生成的临时png文件目录
logs_dir="logs"
x_axis="1920"             # png图片长边像素
y_axis="1440"             # png图片宽边像素
count=0

for swf in `ls $source_dir` ;do
  count=$[count+1]
  echo "The $count SWF file is converting ..."
  $work_dir/swfrender -X $x_axis -Y $y_axis $source_dir/$swf -o $png_tmp_dir/output 2>>$logs_dir/swfrender_err.log
  cd $png_tmp_dir
  png_count=0
  for png in `ls` ;do
    mv $png `echo $png| awk -F'-' '{print $2}'`.png
    png_count=$[png_count+1]
  done
  echo "the SWF file converted to $png_count PNG files"

  $work_dir/convert `ls| sort -n` $work_dir/$dest_dir/`echo $swf| awk -F'.' '{print $swf}'`.pdf 2>>$work_dir/$logs_dir/convert_err.log
  echo "the SWF file converted to PDF done!"
  echo "----------------------------------"
  rm *.png
  cd $work_dir
done
echo -e "\n=================================="
echo "$count SWF files converted done!"
