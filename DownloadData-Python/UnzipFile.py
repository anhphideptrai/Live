import os
import zipfile
import DownloadJson

def unzip(path):
    count = 0
    for app in os.listdir(path):
        if app != '.DS_Store':
            appPath = os.path.join(path, app)
            for lesson in os.listdir(appPath):
                lessonPath = os.path.join(appPath, lesson)
                try:
                    zip_ref = zipfile.ZipFile(lessonPath, 'r')
                    zip_ref.extractall(os.path.join('Unzip/'+app, lesson.replace('.zip', '')))
                    zip_ref.close()
                except:
                    print 'BAD app' + app + lesson
                    continue
            count += 1
            print 'count ' + str(count)

if __name__ == '__main__':
    unzip('Data/')