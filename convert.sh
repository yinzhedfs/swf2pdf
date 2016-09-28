#!/bin/bash
# by yinzhedfs

work_dir=`pwd`            # 工作目录
source_dir="swfFiles"     # swf文件存放目录
dest_dir="pdfFiles"       # 转换后的pdf存放目录
png_tmp_dir="tmp"         # swf生成的临时png文件目录
swf_done_dir="swfDone"    # 已完成swd目录
logs_dir="logs"           # 日志目录
x_axis="1920"             # png图片长边像素
y_axis="1440"             # png图片宽边像素
count=0                   # 转换文件计数
thread_nums=4             # 线程数


function swf_convert(){
    echo "The $count SWF file is converting ..."
    filename=$1
    count=$2
    mkdir $png_tmp_dir/$count
    tmp_dir=$png_tmp_dir/$count
    $work_dir/swfrender -X $x_axis -Y $y_axis $source_dir/$filename -o $tmp_dir/output 2>>$logs_dir/swfrender_err.log
    cd $tmp_dir
    png_list=`ls`
    png_count=`ls| wc -l`
    if [ "$png_count" -gt 1 ];then
        for png in `ls` ;do
            mv $png `echo $png| awk -F'-' '{print $2}'`.png
        done
    fi
    echo "the $count SWF file converted to $png_count PNG files"
   
    # 限制同时只能运行一个convert转换，避免IO堵塞
    convert_threads=`ps aux| grep "$work_dir/convert"| grep -v "grep"| wc -l`
    while [ "$convert_threads" -ge 1 ];do
        sleep 1
        convert_threads=`ps aux| grep "$work_dir/convert"| grep -v "grep"| wc -l`
    done
    $work_dir/convert `ls| sort -n` $work_dir/$dest_dir/`echo $swf| awk -F'.' '{print $1}'`.pdf 2>>$work_dir/$logs_dir/convert_err.log
    echo "* the $count SWF file converted to PDF done!"
    rm -rf $work_dir/$tmp_dir
    mv $work_dir/$source_dir/$filename $work_dir/$swf_done_dir/
}

for swf in `ls $source_dir` ;do
    cd $work_dir
    # 判断线程数量
    swfrender_threads=`ps aux| grep "$work_dir/swfrender"| grep -v 'grep'| wc -l`
    while [ "$swfrender_threads" -ge "$thread_nums" ];do
        sleep 1
        swfrender_threads=`ps aux| grep "$work_dir/swfrender"| grep -v 'grep'| wc -l`
    done
    count=$[count+1]
    swf_convert $swf $count &
    sleep 1
done

# 等待子进程结束
wait
echo -e "\n=================================="
echo "$count SWF files converted done!"
