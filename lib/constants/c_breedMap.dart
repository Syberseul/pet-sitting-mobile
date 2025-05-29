import 'package:flutter_projects/constants/enum.dart';

class BreedInfo {
  final String englishName;
  final String chineseName;
  final List<double> normalWeightRange;

  BreedInfo({
    required this.englishName,
    required this.chineseName,
    required this.normalWeightRange,
  });

  @override
  String toString() {
    return '$chineseName ($englishName), with weight range $normalWeightRange';
  }

  static BreedInfo? getBreedInfo(String englishName) {
    if (englishName.isEmpty) return null;
    return breedMap[englishName];
  }
}

final Map<String, BreedInfo> breedMap = {
  // 简单品种（无子品种）
  'affenpinscher': BreedInfo(
    englishName: 'affenpinscher',
    chineseName: "猴面梗",
    normalWeightRange: [3, 6],
  ),
  'african': BreedInfo(
    englishName: 'african',
    chineseName: "非洲犬",
    normalWeightRange: [20, 30],
  ),
  'airedale': BreedInfo(
    englishName: 'airedale',
    chineseName: "艾尔谷梗",
    normalWeightRange: [20, 30],
  ),
  'akita': BreedInfo(
    englishName: 'akita',
    chineseName: "秋田犬",
    normalWeightRange: [30, 50],
  ),
  'appenzeller': BreedInfo(
    englishName: 'appenzeller',
    chineseName: "阿彭策尔山犬",
    normalWeightRange: [22, 32],
  ),
  'basenji': BreedInfo(
    englishName: 'basenji',
    chineseName: "巴仙吉犬",
    normalWeightRange: [9, 11],
  ),
  'beagle': BreedInfo(
    englishName: 'beagle',
    chineseName: "比格犬",
    normalWeightRange: [9, 11],
  ),
  'bluetick': BreedInfo(
    englishName: 'bluetick',
    chineseName: "蓝斑猎浣熊犬",
    normalWeightRange: [20, 36],
  ),
  'borzoi': BreedInfo(
    englishName: 'borzoi',
    chineseName: "俄罗斯狼犬",
    normalWeightRange: [34, 48],
  ),
  'bouvier': BreedInfo(
    englishName: 'bouvier',
    chineseName: "布维耶犬",
    normalWeightRange: [30, 50],
  ),
  'boxer': BreedInfo(
    englishName: 'boxer',
    chineseName: "拳师犬",
    normalWeightRange: [25, 32],
  ),
  'brabancon': BreedInfo(
    englishName: 'brabancon',
    chineseName: "布鲁塞尔格里芬犬",
    normalWeightRange: [3.5, 6],
  ),
  'briard': BreedInfo(
    englishName: 'briard',
    chineseName: "布里牧犬",
    normalWeightRange: [25, 40],
  ),
  'cavapoo': BreedInfo(
    englishName: 'cavapoo',
    chineseName: "卡瓦普犬",
    normalWeightRange: [5, 12],
  ),
  'cavoodle': BreedInfo(
    englishName: 'cavoodle',
    chineseName: "奥斯卡贵宾",
    normalWeightRange: [5, 12],
  ),
  'chihuahua': BreedInfo(
    englishName: 'chihuahua',
    chineseName: "吉娃娃",
    normalWeightRange: [1.5, 3],
  ),
  'chow': BreedInfo(
    englishName: 'chow',
    chineseName: "松狮犬",
    normalWeightRange: [20, 32],
  ),
  'clumber': BreedInfo(
    englishName: 'clumber',
    chineseName: "克伦伯猎犬",
    normalWeightRange: [25, 39],
  ),
  'cockapoo': BreedInfo(
    englishName: 'cockapoo',
    chineseName: "可卡贵宾犬",
    normalWeightRange: [5, 11],
  ),
  'cotondetulear': BreedInfo(
    englishName: 'cotondetulear',
    chineseName: "棉花面纱犬",
    normalWeightRange: [4, 7],
  ),
  'dalmatian': BreedInfo(
    englishName: 'dalmatian',
    chineseName: "斑点犬",
    normalWeightRange: [20, 32],
  ),
  'dhole': BreedInfo(
    englishName: 'dhole',
    chineseName: "豺犬",
    normalWeightRange: [12, 20],
  ),
  'dingo': BreedInfo(
    englishName: 'dingo',
    chineseName: "澳洲野犬",
    normalWeightRange: [13, 20],
  ),
  'doberman': BreedInfo(
    englishName: 'doberman',
    chineseName: "杜宾犬",
    normalWeightRange: [30, 45],
  ),
  'entlebucher': BreedInfo(
    englishName: 'entlebucher',
    chineseName: "恩特布赫山犬",
    normalWeightRange: [20, 30],
  ),
  'eskimo': BreedInfo(
    englishName: 'eskimo',
    chineseName: "爱斯基摩犬",
    normalWeightRange: [20, 35],
  ),
  'germanshepherd': BreedInfo(
    englishName: 'germanshepherd',
    chineseName: "德国牧羊犬",
    normalWeightRange: [30, 40],
  ),
  'groenendael': BreedInfo(
    englishName: 'groenendael',
    chineseName: "比利时格罗安达犬",
    normalWeightRange: [20, 30],
  ),
  'havanese': BreedInfo(
    englishName: 'havanese',
    chineseName: "哈瓦那犬",
    normalWeightRange: [3, 6],
  ),
  'husky': BreedInfo(
    englishName: 'husky',
    chineseName: "哈士奇",
    normalWeightRange: [16, 27],
  ),
  'keeshond': BreedInfo(
    englishName: 'keeshond',
    chineseName: "荷兰毛狮犬",
    normalWeightRange: [16, 20],
  ),
  'komondor': BreedInfo(
    englishName: 'komondor',
    chineseName: "可蒙犬",
    normalWeightRange: [40, 60],
  ),
  'kuvasz': BreedInfo(
    englishName: 'kuvasz',
    chineseName: "库瓦兹犬",
    normalWeightRange: [30, 52],
  ),
  'labradoodle': BreedInfo(
    englishName: 'labradoodle',
    chineseName: "拉布拉多贵宾犬",
    normalWeightRange: [20, 30],
  ),
  'labrador': BreedInfo(
    englishName: 'labrador',
    chineseName: "拉布拉多犬",
    normalWeightRange: [25, 36],
  ),
  'leonberg': BreedInfo(
    englishName: 'leonberg',
    chineseName: "莱昂伯格犬",
    normalWeightRange: [45, 77],
  ),
  'lhasa': BreedInfo(
    englishName: 'lhasa',
    chineseName: "拉萨犬",
    normalWeightRange: [5, 8],
  ),
  'malamute': BreedInfo(
    englishName: 'malamute',
    chineseName: "阿拉斯加雪橇犬",
    normalWeightRange: [34, 39],
  ),
  'malinois': BreedInfo(
    englishName: 'malinois',
    chineseName: "比利时玛利诺犬",
    normalWeightRange: [20, 30],
  ),
  'maltese': BreedInfo(
    englishName: 'maltese',
    chineseName: "马尔济斯犬",
    normalWeightRange: [2, 4],
  ),
  'mexicanhairless': BreedInfo(
    englishName: 'mexicanhairless',
    chineseName: "墨西哥无毛犬",
    normalWeightRange: [4, 14],
  ),
  'mix': BreedInfo(
    englishName: 'mix',
    chineseName: "混种犬",
    normalWeightRange: [5, 40],
  ),
  'newfoundland': BreedInfo(
    englishName: 'newfoundland',
    chineseName: "纽芬兰犬",
    normalWeightRange: [50, 70],
  ),
  'otterhound': BreedInfo(
    englishName: 'otterhound',
    chineseName: "水獭猎犬",
    normalWeightRange: [30, 55],
  ),
  'papillon': BreedInfo(
    englishName: 'papillon',
    chineseName: "蝴蝶犬",
    normalWeightRange: [2.5, 5],
  ),
  'pekinese': BreedInfo(
    englishName: 'pekinese',
    chineseName: "北京犬",
    normalWeightRange: [3, 6],
  ),
  'pembroke': BreedInfo(
    englishName: 'pembroke',
    chineseName: "彭布罗克柯基犬",
    normalWeightRange: [10, 14],
  ),
  'pitbull': BreedInfo(
    englishName: 'pitbull',
    chineseName: "比特犬",
    normalWeightRange: [14, 27],
  ),
  'pomeranian': BreedInfo(
    englishName: 'pomeranian',
    chineseName: "博美犬",
    normalWeightRange: [1.5, 3.5],
  ),
  'pug': BreedInfo(
    englishName: 'pug',
    chineseName: "巴哥犬",
    normalWeightRange: [6, 8],
  ),
  'puggle': BreedInfo(
    englishName: 'puggle',
    chineseName: "巴哥混血犬",
    normalWeightRange: [7, 14],
  ),
  'redbone': BreedInfo(
    englishName: 'redbone',
    chineseName: "红骨猎浣熊犬",
    normalWeightRange: [20, 32],
  ),
  'rottweiler': BreedInfo(
    englishName: 'rottweiler',
    chineseName: "罗威纳犬",
    normalWeightRange: [35, 60],
  ),
  'saluki': BreedInfo(
    englishName: 'saluki',
    chineseName: "萨路基犬",
    normalWeightRange: [18, 27],
  ),
  'samoyed': BreedInfo(
    englishName: 'samoyed',
    chineseName: "萨摩耶犬",
    normalWeightRange: [20, 30],
  ),
  'schipperke': BreedInfo(
    englishName: 'schipperke',
    chineseName: "比利时小牧羊犬",
    normalWeightRange: [4, 7],
  ),
  'sharpei': BreedInfo(
    englishName: 'sharpei',
    chineseName: "沙皮犬",
    normalWeightRange: [18, 25],
  ),
  'shiba': BreedInfo(
    englishName: 'shiba',
    chineseName: "柴犬",
    normalWeightRange: [8, 10],
  ),
  'shihtzu': BreedInfo(
    englishName: 'shihtzu',
    chineseName: "西施犬",
    normalWeightRange: [4, 7],
  ),
  'stbernard': BreedInfo(
    englishName: 'stbernard',
    chineseName: "圣伯纳犬",
    normalWeightRange: [60, 90],
  ),
  'tervuren': BreedInfo(
    englishName: 'tervuren',
    chineseName: "比利时特伏丹犬",
    normalWeightRange: [20, 30],
  ),
  'vizsla': BreedInfo(
    englishName: 'vizsla',
    chineseName: "维兹拉犬",
    normalWeightRange: [20, 30],
  ),
  'weimaraner': BreedInfo(
    englishName: 'weimaraner',
    chineseName: "魏玛犬",
    normalWeightRange: [25, 40],
  ),
  'whippet': BreedInfo(
    englishName: 'whippet',
    chineseName: "惠比特犬",
    normalWeightRange: [10, 20],
  ),

  // 复合品种（有子品种）
  'australian kelpie': BreedInfo(
    englishName: 'australian kelpie',
    chineseName: "澳大利亚卡尔比犬",
    normalWeightRange: [14, 20],
  ),
  'australian shepherd': BreedInfo(
    englishName: 'australian shepherd',
    chineseName: "澳大利亚牧羊犬",
    normalWeightRange: [18, 30],
  ),
  'bakharwal indian': BreedInfo(
    englishName: 'bakharwal indian',
    chineseName: "印度巴克瓦犬",
    normalWeightRange: [30, 45],
  ),
  'bulldog boston': BreedInfo(
    englishName: 'bulldog boston',
    chineseName: "波士顿斗牛犬",
    normalWeightRange: [5, 11],
  ),
  'bulldog english': BreedInfo(
    englishName: 'bulldog english',
    chineseName: "英国斗牛犬",
    normalWeightRange: [18, 25],
  ),
  'bulldog french': BreedInfo(
    englishName: 'bulldog french',
    chineseName: "法国斗牛犬",
    normalWeightRange: [9, 13],
  ),
  'bullterrier staffordshire': BreedInfo(
    englishName: 'bullterrier staffordshire',
    chineseName: "斯塔福德牛头梗",
    normalWeightRange: [13, 17],
  ),
  'cattledog australian': BreedInfo(
    englishName: 'cattledog australian',
    chineseName: "澳洲牧牛犬",
    normalWeightRange: [15, 22],
  ),
  'chippiparai indian': BreedInfo(
    englishName: 'chippiparai indian',
    chineseName: "印度奇皮帕莱犬",
    normalWeightRange: [15, 25],
  ),
  'collie border': BreedInfo(
    englishName: 'collie border',
    chineseName: "边境柯利牧羊犬",
    normalWeightRange: [14, 20],
  ),
  'corgi cardigan': BreedInfo(
    englishName: 'corgi cardigan',
    chineseName: "卡迪根柯基犬",
    normalWeightRange: [11, 17],
  ),
  'dane great': BreedInfo(
    englishName: 'dane great',
    chineseName: "大丹犬",
    normalWeightRange: [50, 90],
  ),
  'danish swedish': BreedInfo(
    englishName: 'danish swedish',
    chineseName: "瑞典丹麦犬",
    normalWeightRange: [30, 35],
  ),
  'deerhound scottish': BreedInfo(
    englishName: 'deerhound scottish',
    chineseName: "苏格兰猎鹿犬",
    normalWeightRange: [36, 45],
  ),
  'elkhound norwegian': BreedInfo(
    englishName: 'elkhound norwegian',
    chineseName: "挪威猎鹿犬",
    normalWeightRange: [20, 25],
  ),
  'finnish lapphund': BreedInfo(
    englishName: 'finnish lapphund',
    chineseName: "芬兰拉普猎犬",
    normalWeightRange: [15, 24],
  ),
  'frise bichon': BreedInfo(
    englishName: 'frise bichon',
    chineseName: "比熊犬",
    normalWeightRange: [5, 10],
  ),
  'gaddi indian': BreedInfo(
    englishName: 'gaddi indian',
    chineseName: "印度加迪犬",
    normalWeightRange: [25, 40],
  ),
  'greyhound indian': BreedInfo(
    englishName: 'greyhound indian',
    chineseName: "印度灵缇犬",
    normalWeightRange: [25, 30],
  ),
  'greyhound italian': BreedInfo(
    englishName: 'greyhound italian',
    chineseName: "意大利灵缇犬",
    normalWeightRange: [2.5, 5],
  ),
  'hound afghan': BreedInfo(
    englishName: 'hound afghan',
    chineseName: "阿富汗猎犬",
    normalWeightRange: [23, 27],
  ),
  'hound basset': BreedInfo(
    englishName: 'hound basset',
    chineseName: "巴吉度猎犬",
    normalWeightRange: [20, 29],
  ),
  'hound blood': BreedInfo(
    englishName: 'hound blood',
    chineseName: "血猎犬",
    normalWeightRange: [36, 50],
  ),
  'hound english': BreedInfo(
    englishName: 'hound english',
    chineseName: "英国猎犬",
    normalWeightRange: [25, 35],
  ),
  'hound ibizan': BreedInfo(
    englishName: 'hound ibizan',
    chineseName: "伊比赞猎犬",
    normalWeightRange: [20, 29],
  ),
  'hound plott': BreedInfo(
    englishName: 'hound plott',
    chineseName: "普罗特猎犬",
    normalWeightRange: [20, 25],
  ),
  'hound walker': BreedInfo(
    englishName: 'hound walker',
    chineseName: "步行猎犬",
    normalWeightRange: [20, 30],
  ),
  'mastiff bull': BreedInfo(
    englishName: 'mastiff bull',
    chineseName: "斗牛獒犬",
    normalWeightRange: [45, 60],
  ),
  'mastiff english': BreedInfo(
    englishName: 'mastiff english',
    chineseName: "英国獒犬",
    normalWeightRange: [70, 120],
  ),
  'mastiff indian': BreedInfo(
    englishName: 'mastiff indian',
    chineseName: "印度獒犬",
    normalWeightRange: [70, 90],
  ),
  'mastiff tibetan': BreedInfo(
    englishName: 'mastiff tibetan',
    chineseName: "藏獒",
    normalWeightRange: [70, 90],
  ),
  'mountain bernese': BreedInfo(
    englishName: 'mountain bernese',
    chineseName: "伯恩山犬",
    normalWeightRange: [35, 55],
  ),
  'mountain swiss': BreedInfo(
    englishName: 'mountain swiss',
    chineseName: "瑞士山地犬",
    normalWeightRange: [30, 50],
  ),
  'mudhol indian': BreedInfo(
    englishName: 'mudhol indian',
    chineseName: "印度穆德霍尔犬",
    normalWeightRange: [15, 25],
  ),
  'ovcharka caucasian': BreedInfo(
    englishName: 'ovcharka caucasian',
    chineseName: "高加索牧羊犬",
    normalWeightRange: [45, 70],
  ),
  'pariah indian': BreedInfo(
    englishName: 'pariah indian',
    chineseName: "印度帕利亚犬",
    normalWeightRange: [15, 25],
  ),
  'pinscher miniature': BreedInfo(
    englishName: 'pinscher miniature',
    chineseName: "迷你平斯澈犬",
    normalWeightRange: [4, 6],
  ),
  'pointer german': BreedInfo(
    englishName: 'pointer german',
    chineseName: "德国指示犬",
    normalWeightRange: [20, 32],
  ),
  'pointer germanlonghair': BreedInfo(
    englishName: 'pointer germanlonghair',
    chineseName: "德国长毛指示犬",
    normalWeightRange: [25, 35],
  ),
  'poodle medium': BreedInfo(
    englishName: 'poodle medium',
    chineseName: "中型贵宾犬",
    normalWeightRange: [10, 15],
  ),
  'poodle miniature': BreedInfo(
    englishName: 'poodle miniature',
    chineseName: "迷你贵宾犬",
    normalWeightRange: [5, 9],
  ),
  'poodle standard': BreedInfo(
    englishName: 'poodle standard',
    chineseName: "标准贵宾犬",
    normalWeightRange: [20, 32],
  ),
  'poodle toy': BreedInfo(
    englishName: 'poodle toy',
    chineseName: "玩具贵宾犬",
    normalWeightRange: [3, 4],
  ),
  'rajapalayam indian': BreedInfo(
    englishName: 'rajapalayam indian',
    chineseName: "印度拉贾帕拉亚姆犬",
    normalWeightRange: [25, 30],
  ),
  'retriever chesapeake': BreedInfo(
    englishName: 'retriever chesapeake',
    chineseName: "切萨皮克寻回犬",
    normalWeightRange: [25, 36],
  ),
  'retriever curly': BreedInfo(
    englishName: 'retriever curly',
    chineseName: "卷毛寻回犬",
    normalWeightRange: [25, 40],
  ),
  'retriever flatcoated': BreedInfo(
    englishName: 'retriever flatcoated',
    chineseName: "平毛寻回犬",
    normalWeightRange: [25, 36],
  ),
  'retriever golden': BreedInfo(
    englishName: 'retriever golden',
    chineseName: "金毛寻回犬",
    normalWeightRange: [25, 34],
  ),
  'ridgeback rhodesian': BreedInfo(
    englishName: 'ridgeback rhodesian',
    chineseName: "罗得西亚脊背犬",
    normalWeightRange: [32, 36],
  ),
  'schnauzer giant': BreedInfo(
    englishName: 'schnauzer giant',
    chineseName: "巨型雪纳瑞",
    normalWeightRange: [25, 48],
  ),
  'schnauzer miniature': BreedInfo(
    englishName: 'schnauzer miniature',
    chineseName: "迷你雪纳瑞",
    normalWeightRange: [5, 9],
  ),
  'segugio italian': BreedInfo(
    englishName: 'segugio italian',
    chineseName: "意大利塞古吉奥犬",
    normalWeightRange: [18, 28],
  ),
  'setter english': BreedInfo(
    englishName: 'setter english',
    chineseName: "英国塞特犬",
    normalWeightRange: [20, 36],
  ),
  'setter gordon': BreedInfo(
    englishName: 'setter gordon',
    chineseName: "戈登塞特犬",
    normalWeightRange: [20, 36],
  ),
  'setter irish': BreedInfo(
    englishName: 'setter irish',
    chineseName: "爱尔兰塞特犬",
    normalWeightRange: [25, 32],
  ),
  'sheepdog english': BreedInfo(
    englishName: 'sheepdog english',
    chineseName: "英国牧羊犬",
    normalWeightRange: [18, 30],
  ),
  'sheepdog indian': BreedInfo(
    englishName: 'sheepdog indian',
    chineseName: "印度牧羊犬",
    normalWeightRange: [20, 30],
  ),
  'sheepdog shetland': BreedInfo(
    englishName: 'sheepdog shetland',
    chineseName: "喜乐蒂牧羊犬",
    normalWeightRange: [5, 11],
  ),
  'spaniel blenheim': BreedInfo(
    englishName: 'spaniel blenheim',
    chineseName: "布伦海姆西班牙猎犬",
    normalWeightRange: [5, 8],
  ),
  'spaniel brittany': BreedInfo(
    englishName: 'spaniel brittany',
    chineseName: "布列塔尼猎犬",
    normalWeightRange: [14, 20],
  ),
  'spaniel cocker': BreedInfo(
    englishName: 'spaniel cocker',
    chineseName: "可卡犬",
    normalWeightRange: [10, 14],
  ),
  'spaniel irish': BreedInfo(
    englishName: 'spaniel irish',
    chineseName: "爱尔兰西班牙猎犬",
    normalWeightRange: [16, 20],
  ),
  'spaniel japanese': BreedInfo(
    englishName: 'spaniel japanese',
    chineseName: "日本西班牙猎犬",
    normalWeightRange: [5, 10],
  ),
  'spaniel sussex': BreedInfo(
    englishName: 'spaniel sussex',
    chineseName: "苏塞克斯猎犬",
    normalWeightRange: [16, 20],
  ),
  'spaniel welsh': BreedInfo(
    englishName: 'spaniel welsh',
    chineseName: "威尔士西班牙猎犬",
    normalWeightRange: [15, 20],
  ),
  'spitz indian': BreedInfo(
    englishName: 'spitz indian',
    chineseName: "印度尖嘴犬",
    normalWeightRange: [15, 25],
  ),
  'spitz japanese': BreedInfo(
    englishName: 'spitz japanese',
    chineseName: "日本尖嘴犬",
    normalWeightRange: [5, 10],
  ),
  'springer english': BreedInfo(
    englishName: 'springer english',
    chineseName: "英国史宾格犬",
    normalWeightRange: [20, 25],
  ),
  'terrier american': BreedInfo(
    englishName: 'terrier american',
    chineseName: "美国梗犬",
    normalWeightRange: [5, 7],
  ),
  'terrier australian': BreedInfo(
    englishName: 'terrier australian',
    chineseName: "澳大利亚梗犬",
    normalWeightRange: [5, 7],
  ),
  'terrier bedlington': BreedInfo(
    englishName: 'terrier bedlington',
    chineseName: "贝灵顿梗",
    normalWeightRange: [8, 10],
  ),
  'terrier border': BreedInfo(
    englishName: 'terrier border',
    chineseName: "边境梗",
    normalWeightRange: [5, 7],
  ),
  'terrier cairn': BreedInfo(
    englishName: 'terrier cairn',
    chineseName: "凯恩梗",
    normalWeightRange: [6, 7],
  ),
  'terrier dandie': BreedInfo(
    englishName: 'terrier dandie',
    chineseName: "丹迪丁蒙梗",
    normalWeightRange: [8, 11],
  ),
  'terrier fox': BreedInfo(
    englishName: 'terrier fox',
    chineseName: "猎狐梗",
    normalWeightRange: [7, 9],
  ),
  'terrier irish': BreedInfo(
    englishName: 'terrier irish',
    chineseName: "爱尔兰梗",
    normalWeightRange: [11, 12],
  ),
  'terrier kerryblue': BreedInfo(
    englishName: 'terrier kerryblue',
    chineseName: "凯利蓝梗",
    normalWeightRange: [15, 18],
  ),
  'terrier lakeland': BreedInfo(
    englishName: 'terrier lakeland',
    chineseName: "湖畔梗",
    normalWeightRange: [7, 8],
  ),
  'terrier norfolk': BreedInfo(
    englishName: 'terrier norfolk',
    chineseName: "诺福克梗",
    normalWeightRange: [5, 6],
  ),
  'terrier norwich': BreedInfo(
    englishName: 'terrier norwich',
    chineseName: "诺维奇梗",
    normalWeightRange: [5, 6],
  ),
  'terrier patterdale': BreedInfo(
    englishName: 'terrier patterdale',
    chineseName: "帕特代尔梗",
    normalWeightRange: [5, 6],
  ),
  'terrier russell': BreedInfo(
    englishName: 'terrier russell',
    chineseName: "罗素梗",
    normalWeightRange: [4, 7],
  ),
  'terrier scottish': BreedInfo(
    englishName: 'terrier scottish',
    chineseName: "苏格兰梗",
    normalWeightRange: [8, 10],
  ),
  'terrier sealyham': BreedInfo(
    englishName: 'terrier sealyham',
    chineseName: "西里汉梗",
    normalWeightRange: [8, 9],
  ),
  'terrier silky': BreedInfo(
    englishName: 'terrier silky',
    chineseName: "丝毛梗",
    normalWeightRange: [4, 5],
  ),
  'terrier tibetan': BreedInfo(
    englishName: 'terrier tibetan',
    chineseName: "西藏梗",
    normalWeightRange: [4, 7],
  ),
  'terrier toy': BreedInfo(
    englishName: 'terrier toy',
    chineseName: "玩具梗",
    normalWeightRange: [2, 3],
  ),
  'terrier welsh': BreedInfo(
    englishName: 'terrier welsh',
    chineseName: "威尔士梗",
    normalWeightRange: [9, 10],
  ),
  'terrier westhighland': BreedInfo(
    englishName: 'terrier westhighland',
    chineseName: "西高地白梗",
    normalWeightRange: [7, 10],
  ),
  'terrier wheaten': BreedInfo(
    englishName: 'terrier wheaten',
    chineseName: "软毛麦色梗",
    normalWeightRange: [14, 18],
  ),
  'terrier yorkshire': BreedInfo(
    englishName: 'terrier yorkshire',
    chineseName: "约克夏梗",
    normalWeightRange: [2, 3],
  ),
  'waterdog spanish': BreedInfo(
    englishName: 'waterdog spanish',
    chineseName: "西班牙水犬",
    normalWeightRange: [14, 22],
  ),
  'wolfhound irish': BreedInfo(
    englishName: 'wolfhound irish',
    chineseName: "爱尔兰猎狼犬",
    normalWeightRange: [45, 55],
  ),
};

final Map<DogSize, double> dailyPriceList = {
  DogSize.xSmall: 30,
  DogSize.small: 30,
  DogSize.medium: 35,
  DogSize.large: 40,
  DogSize.xLarge: 50
};