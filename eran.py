import os.path
import sys
from zipfile import ZipFile

str = "abcdefghijklmnopqrstuvwxyz";
path = 'd:/eran/python'
version='1.2.0'

def create_arr(str):
   array= [char for char in str];
   return array;

def check_files(file_path):
   boo=os.path.isfile(file_path);
   return boo;

#create array with chars
arr=create_arr(str);

#one iteration on array with checks of *.txt and *.zip
for i in range(len(arr)):
  filename=arr[i]
  open(f'{filename}.txt','w');
  if not check_files(f'{path}/{filename}.txt'):
     sys.exit("no such file f'{path}/{filename}.txt'")

  zipObj = ZipFile(f'{path}/{filename}_{version}.zip', 'w')
  zipObj.write(f'{filename}.txt');
  zipObj.close();
  if not check_files(f'{path}/{filename}_{version}.zip'):
     sys.exit("no such file f'{path}/{filename}_{version}.zip'")