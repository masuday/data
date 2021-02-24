#
# usage: awk -v posa=[position of animal ID in renf90.dat] -v posm=[position of dam ID in renf90.dat] conv_mat_to_siremgs.awk renaddxx.ped renf90.dat
#
# example:
#   awk -v posa=5 -v posm=6 conv_mat_to_siremgs.awk renadd04.ped renf90.dat
#
BEGIN{
   if(posa<1){
      print "usage: awk -v posa=[animal pos in data] -v posm=[dam pos in data] conv_mat_to_siremgs.awk renadd04.ped renf90.dat"; 
      exit
   }
}
FILENAME==ARGV[1]{
   sire[$1] = $2
   dam[$1] = $3
}
FILENAME!=ARGV[1]{
   sid = sire[$posa] + 0
   if(posm>0){ mgsid = sire[$posm] + 0 }
   else      { mgsid = 0 }
   if(sid>0){ sireped[sid]++; }
   if(mgsid>0){ sireped[sid]++; }
   print $0,sid,mgsid > "renf90sire.dat"
}
END{
   for(sid in sireped){
      ssid = sire[sid] + 0
      mgsid = sire[dam[sid]] + 0
      print sid,ssid,mgsid > "renaddsire.ped"
   }
}

