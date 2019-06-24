mv report report.bak
curl -H 'Cache-Control: no-cache' http://news.ceic.ac.cn/ > source
cat source | grep '<td align="center" style="padding-left: 20px">' > zhenji
cat source | grep '<td align="center" style="width: 155px;">' > timee
cat source | grep '<td align="center">' > sd
cat source | grep '<td align="left"><a href="' > wz
zhenji=`sed -n '1p'  zhenji | sed 's/^[ \t]*//g'`
zj=${zhenji#'<td align="center" style="padding-left: 20px">'}
wz=`sed -n '1p'  wz | sed 's/^[ \t]*//g'`
wzz=${wz#'<td align="left">'}
sd=`sed -n '1p'  sd | sed 's/^[ \t]*//g'`
sdd=${sd#'<td align="center">'}
timee=`sed -n '1p'  timee | sed 's/^[ \t]*//g'`
timeee=${timee#'<td align="center" style="width: 155px;">'}
rm zhenji sd wz timee source
if [[ ${timeee%'</td>'} == "" ]]; then
exit
fi
echo "地震速报:" > report
echo "时间: "${timeee%'</td>'} >> report
echo "位置: "${wzz%'</td>'} >> report
echo "震级(M): "${zj%'</td>'} >> report
echo "震源深度: "${sdd%'</td>'} "km" >> report
re=`cat report`
pd=`diff report report.bak`
if [[ $pd == '' ]]; then
echo "同"
else
echo "不"
python3 push.py
fi
