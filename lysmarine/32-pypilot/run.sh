#!/bin/bash -e
apt-get install -y -q python-setuptools python-gps python-serial libpython-dev \
python-numpy python-scipy swig python-pillow python-flask python-socketio \
python-pip python-pylirc  python-flask python-gevent-websocket \
python-wxgtk4.0 python-opengl python-wxtools

if [ $LMBUILD == raspbian ] ;then
	apt-get install -y -q wiringpi
fi

pip install wheel
pip install pyglet ujson PyOpenGL PyWavefront pyudev flask_socketio

echo "Install RTIMULib2 as a (dep of Pypilot) : "
git clone --depth=1 https://github.com/seandepagnier/RTIMULib2
pushd RTIMULib2/Linux/python
	python setup.py install
popd
rm -rf RTIMULib2

echo "Install Pypilot : "
pushd /
	git clone https://github.com/pypilot/pypilot.git
	pushd ./pypilot
		git checkout db173ae4409aba2900dfd58c50bf8a409cd954e7 # Forced regression due to broken GTK GUI
	popd 

	git clone --depth=1 https://github.com/pypilot/pypilot_data.git
	cp -rv pypilot_data/* pypilot
	rm -rf pypilot_data

	pushd ./pypilot
		python setup.py build
		python setup.py install
	pushd ./scripts/debian/
	cp -r etc/systemd/system/* /etc/systemd/system/

popd; popd
rm -rf pypilot
popd

install -d -v -o 1000 -g 1000 /home/user/.pypilot
install    -v -o 1000 -g 1000 $FILE_FOLDER/signalk.conf "/home/user/.pypilot/"
#install    -v                 $FILE_FOLDER/pypilot_control.desktop "/usr/share/applications/"
install    -v                 $FILE_FOLDER/pypilot_calibration.desktop "/usr/share/applications/"
install    -v                 $FILE_FOLDER/pypilot_webapp.desktop "/usr/share/applications/"
install    -v -o 1000 -g 1000 $FILE_FOLDER/webapp.conf "/home/user/.pypilot/"
