import json
import os
import sys
import getopt
import shutil
import urllib
from random import shuffle

def load_data(data_path, key = None):
    data = None
    
    if data_path is not None:
        # try to open the file as json
        with open(data_path, 'r') as file:
            data = json.load(file)
    if key is not None:
        return data[key]
    else:
        return data

def create_output_file_if_not_exist(path):
    basedir = os.path.dirname(path)
    if not os.path.exists(basedir):
        os.makedirs(basedir)

def download_data(image_url, video_url, output_dir, count = None):
    
    tmp_img = image_url.split('/')
    tmp_video = video_url.split('/')
        
    category_name = tmp_img[len(tmp_img) - 2]
    if count is not None:
        img_name = 'thenewest' + str(count) + '.jpg'
        video_name = 'thenewest' + str(count) + '.mov'
    else:
        img_name = tmp_img[len(tmp_img) - 1]
        video_name = tmp_video[len(tmp_video) - 1]
    
    create_output_file_if_not_exist(output_dir)
        
    file1 = urllib.URLopener()
    file1.retrieve(image_url, os.path.join(output_dir, img_name))
        
    file2 = urllib.URLopener()
    file2.retrieve(video_url, os.path.join(output_dir, video_name))


def dowload_data_json_2():
    
    all = load_data('json/live-photo2.json', 'livephotos')[0]['items']
    
    count = 0
    for item in all:
        
        count += 1
        print str(count)
        
        image_url = item['image']
        video_url = item['video']
        
        tmp_img = image_url.split('/')
        
        category_name = tmp_img[len(tmp_img) - 2]
        output_dir = 'download/' + category_name + '/'

        download_data(image_url, video_url, output_dir)

def dowload_data_json_1():
    all = load_data('json/live-photo1.json')
    items = all['links']
    count = 303


    for item in items:
        if '.jpg' in item:
            count += 1
            image_url = item
            video_url = item.replace('.jpg', '.mov')
        
            output_dir = 'download/TheNewest/'
            download_data(image_url, video_url, output_dir, count)
        
        
            print 'new: ' + str(count) +'/'+ str(len(items))

def genere_json1():
    root_dir = 'download/'
    categories = {}
    count_total = 0
    id_item = 0
    for category in os.listdir(root_dir):
        if category != '.DS_Store':
            sub_dir = os.path.join(root_dir, category)
            images = []
            videos = []
            for file in os.listdir(sub_dir):
                if '.jpg' in file.lower():
                    images.append(file)
                elif '.mov' in file.lower():
                    videos.append(file)
            tmps = []
            count = 0
            for img in images:
                for vid in videos:
                    if img.split('.')[0] == vid.split('.')[0]:
                        count += 1
                        count_total += 1
                        video_size = os.stat(os.path.join(sub_dir, vid)).st_size
                        tmps.append({'image':img, 'video':vid, 'video_size': video_size})
            shuffle(tmps)
            items = {}
            for item in tmps:
                id_item += 1
                id = str(id_item).zfill(3)
                items[id] = item
            categories[category] = {'count':count, 'items': items}

    with open('output/data.json', 'w') as outfile:
        json.dump({'root':{'total':count_total, 'Categories':categories}}, outfile, sort_keys=True)

def genere_json2():
    all = load_data('json/data.json')['root']['Categories']
    items = {}
    all_items = []
    data = {}
    for category in sorted(all.keys()):
        tmps = all[category]['items']
        all_items += tmps.keys()
        tmp = tmps.keys()
        shuffle(tmp)
        items[category] = tmp
        shuffle(all_items)
        items['0All Live Wallpapers'] = all_items
        for key, value in tmps.iteritems():
            data[key] = value
    
    count_total = len(data.keys())
    with open('output/data1.json', 'w') as outfile:
        json.dump({'total':count_total, 'Categories':items, 'data':data}, outfile, sort_keys=True)

def downloadDraw():
    count = 1486
    with open('json/draw.txt') as f:
        for line in f:
            tmp = line.split('|')
            if len(tmp[0]) > 1:
                lesson = 'lesson' + tmp[0] + '.zip'
            else:
                lesson = 'lesson' + '0' + tmp[0] + '.zip'
            app    = 'app' + tmp[1].strip()
            link = 'http://storage.googleapis.com/orgit-prod-bucket/6000334795177984/zipfile/' + app + '/' + lesson
            
            output_dir = 'download/' + app + '/'
            create_output_file_if_not_exist(output_dir)
            try:
                file1 = urllib.URLopener()
                file1.retrieve(link, os.path.join(output_dir, lesson))
            except urllib.error.URLError as e:
                print 'Error: ' + link
            print count
            count += 1

def downLiveItems():
    count   = 0
    all     = load_data('json/live_backup.json')
    items   = all['data']
    for key in items.keys():
        count += 1
        item = items[key]
        category    = item['category']
        sever       = 'http://storage.googleapis.com/sweat_pea_apps/wallpaper_live/'+category+'/'
        image_url   = sever + item['image']
        video_url   = sever + item['video']
        output_dir  = 'download/'+category+'/'
        download_data(image_url, video_url, output_dir, count)
        print 'new: ' + str(count) +'/'+ str(len(items)) + ' URL: ' + image_url

if __name__ == '__main__':
    downLiveItems()




