function test_suite=test_hns()
  initTestSuite;
end
function test_hns_()
     % data = rndnorm(0, 1,20,1) 
  data = [-0.0233845632050972   0.9070186193622006;... 
           0.6529594866766634   1.3689145060433903;... 
           0.4477857310723146  -0.6311953712037597;... 
          -1.9256785038579962   0.5886257667993168;... 
          -0.5290011931824666  -0.3602090880229930]; 
  assert(hns(data,'epan'), [1.73513679136905, 1.43948322577017], 1e-10); 
  assert(hns(data,'biwe'), [2.05555487703312, 1.70530460760076], 1e-10); 
  assert(hns(data,'triw'), [2.33418149081877, 1.93645545333964], 1e-10); 
  assert(hns(data,'tria'), [1.90615281623682, 1.58135947458212], 1e-10); 
  assert(hns(data,'gaus'), [0.783780547013426, 0.650230549961770], 1e-10); 
  assert(hns(data,'rect'), [1.36382287194830, 1.13143825711994], 1e-10); 
  assert(hns(data,'lapl'), [0.579817701798895, 0.481021358025369], 1e-10); 
  assert(hns(data,'logi'), [0.438140924596874, 0.363485181466877], 1e-10);
end
