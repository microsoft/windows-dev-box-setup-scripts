# Install python
choco install python --version 3.5.4 -y

# Refresh path
refreshenv

# Update pip
python -m pip install --upgrade pip

# Install ML related python packages through pip
pip install numpy
pip install scipy
pip install pandas
pip install matplotlib
pip install tensorflow
pip install keras

# Get Visual Studio C++ Redistributables
choco install vcredist2015 
