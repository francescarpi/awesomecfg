sudo pacman -S pavucontrol-qt zenity

cd $HOME/.config

if [ -f awesome ];
then
    mv awesome awesome.backup
fi

ln -s $HOME/.awesomecfg $HOME/.config/awesome

cd $HOME

echo 'Done!'
