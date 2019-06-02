function main()

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    month = 12;  %ѵ���·�
    day_start = 5; %��ʼ����
    day_len = 5;  %ѵ������
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    file_path = '2018����Ԥ������';
    map_maxmin = [];
    output = [];

    for day = day_start:1:(day_start + day_len - 1)
        [raw_data, raw_max ,raw_min] = read_load_data_from_excel(file_path, month ,day);
        data_temp =  my_map(1, raw_data, raw_max, raw_min, 1, 0);
        map_maxmin = cat(1, map_maxmin, [0 1]);
        output = cat(1, output, data_temp);
        target_day = day + 1;
    end

    [target_data, target_max, target_min] = read_load_data_from_excel(file_path, month ,target_day);
    t_d =  my_map(1, target_data, target_max, target_min, 1, 0);

    net = newff(map_maxmin, [6,40,1], {'tansig','logsig','purelin'}, 'traincgf');

    net.trainParam.epochs = 1000000;%��������������
    net.trainParam.goal = 0.001;%�����������ѵ����Ŀ�����
    net.trainParam.lr = 0.1;%ѧϰ��

    goal_net = train(net, output, t_d);%ѵ�������磬����ѵ���õ����������¼

    Y = sim(goal_net, output);
    goal = my_map(0, Y', target_max, target_min, 1, 0);
    
    t=1:1:96;
    plot(t,target_data,t,goal,'r')

    goal'

end

