for f in $(find . -iname "*.py"); do 2to3 -w $f; done
pip install -r requirements.txt