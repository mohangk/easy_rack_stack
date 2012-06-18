git remote rm ec2
git remote add ec2 ssh://nctx@$1/home/nctx/Pie/current
git deploy setup -s false -r ec2
git deploy init
git push ec2 pie_in_a_box:master
