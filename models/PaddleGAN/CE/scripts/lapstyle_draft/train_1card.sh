export FLAGS_cudnn_deterministic=True
cd ${Project_path}
sed -i 's/epochs/total_iters/g' configs/lapstyle_draft.yaml #将epcoh换为iter
sed -i 's/decay_total_iters/decay_epochs/g' configs/lapstyle_draft.yaml #恢复学习率衰减字段
sed -i 's/interval:/interval: 99999 #/g' configs/lapstyle_draft.yaml #将epcoh换为iter

rm -rf data
ln -s ${Data_path} data
if [ ! -d "log" ]; then
  mkdir log
fi
if [ ! -d "../log" ]; then
  mkdir ../log
fi
python -m pip install -r requirements.txt

sed -i 's!num_workers: 16!num_workers: 4!g' configs/lapstyle_draft.yml

python tools/main.py -c configs/lapstyle_draft.yaml -o total_iters=100 log_config.interval=10 > log/lapstyle_draft_1card.log 2>&1
cat log/lapstyle_draft_1card.log | grep " INFO: Iter: 100/100" > ../log/lapstyle_draft_1card.log
cat log/lapstyle_draft_1card.log