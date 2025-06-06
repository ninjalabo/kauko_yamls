DATA  := /content/drive/MyDrive/kcb

# 60fps
yc_60fps_1000_dataset:
	tar xf $(DATA)/yc_60fps_1000.tar

yc_60fps_1000_train: yc_60fps_1000_dataset
	for i in `seq 1 2`; do \
	  yolo detect cfg=yc_60fps_1000_p$${i}_train.yaml; \
	done

yc_60fps_1000_train_resume: yc_60fps_1000_dataset
	for i in `seq 1 2`; do \
	  yolo detect cfg=yc_60fps_1000_p$${i}_train.yaml \
	    resume=True model=models/yc_60fps_1000/p$${i}/weights/last.pt; \
	done

yc_60fps_1000_val:
	yolo detect mode=val epochs=1 \
		cfg=yc_60fps_1000_p2_train.yaml \
		model=models/yc_60fps_1000/p2/weights/best.pt

# 30fps
yc_30fps_unlabeled_dataset:
	tar xf $(DATA)/yc_30fps_unlabeled.tar

yc_30fps_predict: yc_30fps_unlabeled_dataset
	yolo predict cfg=yc_30fps_unlabeled_predict.yaml
	labels=runs/detect/predict/labels
	for x in `ls  $p/labels/*.txt`; do \
		cp yc_30fps_unlabeled/`basename $x .txt`.jpg $(labels); \
	done
	tar -cvf labels.tar -C runs/detect/predict labels && cp labels.tar models/

yc_30fps_500_dataset:
	tar xf $(DATA)/yc_30fps_500.tar

yc_30fps_500_train:
	yolo detect cfg=yc_30fps_500_train.yaml

yc_30fps_500_val:
	yolo detect mode=val  epochs=1 \
		cfg=yc_30fps_500_train.yaml \
		model=models/yc_30fps_500/run/weights/best.pt
