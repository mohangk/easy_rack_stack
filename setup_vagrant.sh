git remote rm vagrant
git remote add vagrant ssh://nctx@localhost:2222/home/nctx/Pie/current
git deploy setup -r vagrant 
git deploy init
git push vagrant pie_in_a_box:master
