best=runs/detect/train/weights/best.pt
yolo=yolo cfg=default.yaml model=$(best)
dname=yc_60fps_manual_100
dset=/content/drive/MyDrive/kcb/$(dname).tar

all: predict

data:
	tar xvf $(dset)
	ln -s $(dname) ./data

p1: data
	$(yolo) freeze=11 lr0=0.01 model=yolo11n

p2: p1
	$(yolo)

train: p2

predict: train
	ln -s $(dname)/images/val ./unlabeled
	$(yolo) mode=predict batch=16 conf=0.9 source=./unlabeled save=False
