module Geocoding
  CITIES = {
      "adams" => {
          lat: 43.56523895263672,
          lon: -92.71935272216797,
          county: 'mower',
          zip_codes: ['55909']
      },
      "afton" => {
          lat: 44.902748107910156,
          lon: -92.78353881835938,
          county: 'washington',
          zip_codes: ['55001']
      },
      "aitkin" => {
          lat: 46.53300857543945,
          lon: -93.71025085449219,
          county: 'aitkin',
          zip_codes: ['56431']
      },
      "akeley" => {
          lat: 47.004131317138670,
          lon:  -94.7269515991211,
          county: 'hubbard',
          zip_codes: ['56433']
      },
      "albany" => {
          lat: 45.629959106445310,
          lon: -94.56999969482422,
          county: 'stearns',
          zip_codes: ['56307']
      },
      "albert lea" => {
          lat: 43.648010253906250,
          lon: -93.36827087402344,
          county: 'freeborn',
          zip_codes: ['56007']
      },
      "albertville" => {
          lat: 45.237742000000004,
          lon: -93.6544085,
          county: 'wright',
          zip_codes: ['55301']
      },
      # albuquerque not found (probably NM)
      "alexandria" => {
          lat: 45.88523864746094,
          lon: -95.3775405883789,
          county: 'douglas',
          zip_codes: ['56308']
      },
      # was found as alma city - no zip codes
      "alma" => {
          lat: 44.02246856689453,
          lon: -93.72799682617188,
          county: 'waseca',
          zip_codes: ['']
      },
      # amherst junction not found
      "andover" => {
          lat: 45.233299255371094,
          lon: -93.29134368896484,
          county: 'anoka',
          zip_codes: ['55304']
      },
      "annandale" => {
          lat: 45.26274108886719,
          lon: -94.12442779541016,
          county: 'wright',
          zip_codes: ['55302']
      },
      "anoka" => {
          lat: 45.1977428,
          lon: -93.38717580000001,
          county: 'anoka',
          zip_codes: ['55303']
      },
      "apple valley" => {
          lat: 44.731910705566406,
          lon: -93.217720031738280,
          county: 'dakota',
          zip_codes: ['55124']
      },
      "arden hills" => {
          lat: 45.05023956298828,
          lon: -93.156608581542970,
          county: 'ramsey',
          zip_codes: ['']
      },
      "ashby" => {
          lat: 46.093021392822266,
          lon: -95.81755065917969,
          county: 'grant',
          zip_codes: ['56309']
      },
      "askov" => {
          lat: 46.18661117553711,
          lon: -92.78241729736328,
          county: 'pine',
          zip_codes: ['55704']
      },
      "atwater" => {
          lat: 45.138851165771484,
          lon: -94.77806091308594,
          county: 'kandiyohi',
          zip_codes: ['56209']
      },
      # found as 'new auburn'
      "auburn" => {
          lat: 44.67356872558594,
          lon: -94.22969818115234,
          county: 'sibley',
          zip_codes: ['55366']
      },
      "aurora" => {
          lat: 47.529930114746094,
          lon: -92.23712158203125,
          county: 'saint louis',
          zip_codes: ['55705']
      },
      "austin" => {
          lat: 43.666629791259766,
          lon: -92.97463989257812,
          county: 'mower',
          zip_codes: ['55912']
      },
      "avon" => {
          lat: 45.609130859375,
          lon: -94.45166778564453,
          county: 'stearns',
          zip_codes: ['56310']
      },
      "bagley" => {
          lat: 47.52162170410156,
          lon: -95.39835357666016,
          county: 'clearwater',
          zip_codes: ['56621']
      },
      # balsam lake
      "barnesville" => {
          lat: 46.652179718017580,
          lon: -96.419792175292970,
          county: 'clay',
          zip_codes: ['56514']
      },
      "barnum" => {
          lat: 46.50299835205078,
          lon: -92.68852996826172,
          county: 'carlton',
          zip_codes: ['55707']
      },
      "battle lake" => {
          lat: 46.280521392822266,
          lon: -95.71366119384766,
          county: 'otter tail',
          zip_codes: ['56515']
      },
      "baxter" => {
          lat: 46.343299865722656,
          lon: -94.28666687011719,
          county: 'crow wing',
          zip_codes: ['56425']
      },
      "bayport" => {
          lat: 45.021358489990234,
          lon: -92.78103637695312,
          county: 'washington',
          zip_codes: ['55003']
      },
      "becida" => {
          lat: 47.35411834716797,
          lon: -95.08112335205078,
          county: 'hubbard',
          zip_codes: ['']
      },
      "belle plaine" => {
          lat: 44.62274169921875,
          lon: -93.76856994628906,
          county: 'scott',
          zip_codes: ['56011']
      },
      "bemidji" => {
          lat: 47.478654000000006,
          lon:  -94.89080200000001,
          county: 'beltrami',
          zip_codes: ['56601'],
      },
      "bethel" => {
          lat: 45.40385055541992,
          lon:  -93.26773071289062,
          county: 'anoka',
          zip_codes: ['55005']
      },
      "big lake" => {
          lat: 45.33245849609375,
          lon: -93.74607849121094,
          county: 'sherburne',
          zip_codes: ['55309']
      },
      "bird island" => {
          lat: 44.767459869384766,
          lon: -94.89555358886719,
          county: 'renville',
          zip_codes: ['55310']
      },
      "blaine" => {
          lat: 45.16080093383789,
          lon: -93.23494720458984,
          county: 'anoka',
          zip_codes: ['55434']
      },
      "blooming prairie" => {
          lat: 43.86663055419922,
          lon: -93.05103302001953,
          county: 'steele',
          zip_codes: ['55917']
      },
      "bloomington" => {
          lat: 44.84080123901367,
          lon: -93.29827880859375,
          county: 'hennepin',
          zip_codes: ['55420']
      },
      "bovey" => {
          lat:  47.295501708984375,
          lon: -93.4188232421875,
          county: 'itasca',
          zip_codes: ['55709']
      },
      # boyceville
      "braham" => {
          lat: 45.722740173339844,
          lon:  -93.1707763671875,
          county: 'isanti',
          zip_codes: ['55006']
      },
      "brainerd" => {
          lat: 46.3580207824707,
          lon: -94.2008285522461,
          county: 'crow wing',
          zip_codes: ['56401']
      },
      "brandon" => {
          lat: 45.965240478515625,
          lon: -95.59866333007812,
          county: 'douglas',
          zip_codes: ['56315']
      },
      "breckenridge" => {
          lat: 46.26356887817383,
          lon: -96.58812713623047,
          county: 'wilkin',
          zip_codes: ['56520']
      },
      "breezy point" => {
          lat: 46.59001159667969,
          lon: -94.21981811523438,
          county: 'crow wing',
          zip_codes: ['']
      },
      "britt" => {
          lat: 47.640201568603516,
          lon: -92.525459289550780,
          county: 'saint louis',
          zip_codes: ['55710']
      },
      "brook park" => {
          lat: 45.94940185546875,
          lon:  -93.07549285888672,
          county: 'pine',
          zip_codes: ['55007']
      },
      "brooklyn park" => {
          lat: 45.09413146972656,
          lon: -93.35633850097656,
          county: 'hennepin',
          zip_codes: ['55443']
      },
      "brooklyn center" => {
          lat: 45.076080322265625,
          lon: -93.33273315429688,
          county: 'hennepin',
          zip_codes: ['55430']
      },
      "brooks" => {
          lat: 47.81441116333008,
          lon:  -96.00225830078125,
          county: 'red lake',
          zip_codes: ['56715']
      },
      "browerville" => {
          lat: 46.08580017089844,
          lon: -94.86585998535156,
          county: 'todd',
          zip_codes: ['56438']
      },
      "brownsdale" => {
          lat: 43.740238189697266,
          lon: -92.86934661865234,
          county: 'mower',
          zip_codes: ['55918']
      },
      "buffalo" => {
          lat: 45.17190933227539,
          lon: -93.87468719482422,
          county: 'wright',
          zip_codes: ['55313']
      },
      "burnsville" => {
          lat: 44.767738342285156,
          lon: -93.27771759033203,
          county: 'dakota',
          zip_codes: ['55306']
      },
      "burtrum" => {
          lat: 45.867469787597656,
          lon: -94.68501281738281,
          county: 'todd',
          zip_codes: ['56318']
      },
      "buyck" => {
          lat: 48.121849060058594,
          lon: -92.52349090576172,
          county: 'saint louis',
          zip_codes: ['']
      },
      "byron" => {
          lat: 44.03274154663086,
          lon:  -92.64546203613281,
          county: 'olmstead',
          zip_codes: ['55920']
      },
      "caledonia" => {
          lat: 43.63468933105469,
          lon:  -91.49681091308594,
          county: 'houston',
          zip_codes: ['55921']
      },
      "cambridge" => {
          lat: 45.57273864746094,
          lon: -93.2243881225586,
          county: 'isanti',
          zip_codes: ['55008']
      },
      "canby" => {
          lat: 44.708853000000005,
          lon: -96.27643400000001,
          county: 'yellow medicine',
          zip_codes: ['56220']
      },
      "cannon falls" => {
          lat: 44.50690841674805,
          lon: -92.90547943115234,
          county: 'goodhue',
          zip_codes: ['55009']
      },
      "canton" => {
          lat: 43.52968978881836,
          lon: -91.92987823486328,
          county: 'fillmore',
          zip_codes: ['55922']
      },
      # canvy
      "carlos" => {
          lat: 45.97246170043945,
          lon: -95.2922592163086,
          county: 'douglas',
          zip_codes: ['56319']
      },
      "carlton" => {
          lat: 46.6638298034668,
          lon: -92.42491149902344,
          county: 'carlton',
          zip_codes: ['55718']
      },
      "carver" => {
          lat: 44.76356887817383,
          lon: -93.62579345703125,
          county: 'carver',
          zip_codes: ['55315']
      },
      "cass lake" => {
          lat: 47.379398345947266,
          lon: -94.6041488647461,
          county: 'cass',
          zip_codes: ['56633']
      },
      "center city" => {
          lat: 45.39384841918945,
          lon: -92.81659698486328,
          county: 'chisago',
          zip_codes: ['55012']
      },
      "centerville" => {
          lat: 45.163021087646484,
          lon: -93.05577850341797,
          county: 'anoka',
          zip_codes: ['']
      },
      "champlin" => {
          lat: 45.188853900000005,
          lon: -93.39745380000001,
          county: 'hennepin',
          zip_codes: ['55316']
      },
      "chanhassen" => {
          lat: 44.86219024658203,
          lon:  -93.53079223632812,
          county: 'carver',
          zip_codes: ['55317']
      },
      "chaska" => {
          lat: 44.78940963745117,
          lon: -93.60218048095703,
          county: 'carver',
          zip_codes: ['55318']
      },
      "chatfield" => {
          lat: 43.84552001953125,
          lon: -92.18904876708984,
          county: 'fillmore',
          zip_codes: ['55923']
      },
      "chisago city" => {
          lat: 45.37358093261719,
          lon: -92.88993835449219,
          county: 'chisago',
          zip_codes: ['55013'],
          aliases: ['chisago']
      },
      "chisholm" => {
          lat: 47.48910140991211,
          lon: -92.88379669189453,
          county: 'saint louis',
          zip_codes: ['55719']
      },
      "circle pines" => {
          lat: 45.14857864379883,
          lon:  -93.151611328125,
          county: 'anoka',
          zip_codes: ['55014']
      },
      "clear lake" => {
          lat: 45.444969177246094,
          lon: -93.99887084960938,
          county: 'sherburne',
          zip_codes: ['55319']
      },
      "cloquet" => {
          lat: 46.7216102,
          lon: -92.4593566,
          county: 'carlton',
          zip_codes: ['55720']
      },
      "cold spring" => {
          lat: 45.4557991027832,
          lon: -94.42887878417969,
          county: 'stearns',
          zip_codes: ['56320']
      },
      "coleraine" => {
          lat: 47.2888298034668,
          lon: -93.4277114868164,
          county: 'itasca',
          zip_codes: ['55722']
      },
      "collegeville" => {
          lat: 45.59440994262695,
          lon: -94.36305236816406,
          county: 'stearns',
          zip_codes: ['56321']
      },
      "cologne" => {
          lat: 44.771629333496094,
          lon: -93.7813491821289,
          county: 'carver',
          zip_codes: ['55322']
      },
      "columbia heights" => {
          lat: 45.04079818725586,
          lon: -93.26300048828125,
          county: 'anoka',
          zip_codes: ['55421']
      },
      "cook" => {
          lat: 47.852420806884766,
          lon:  -92.68962097167969,
          county: 'saint louis',
          zip_codes: ['55723']
      },
      "coon rapids" => {
          lat: 45.11996841430664,
          lon: -93.28772735595703,
          county: 'anoka',
          zip_codes: ['55433']
      },
      "cottage grove" => {
          lat:  44.82773971557617,
          lon: -92.94381713867188,
          county: 'washington',
          zip_codes: ['55016']
      },
      "crookston" => {
          lat: 47.774138300000004,
          lon:  -96.6081212,
          county: 'polk',
          zip_codes: ['56716']
      },
      "crosby" => {
          lat: 46.482184800000006,
          lon:  -93.95776120000001,
          county: 'crow wing',
          zip_codes: ['56441']
      },
      "crystal" => {
          lat: 45.03274154663086,
          lon:  -93.3602294921875,
          county: 'hennepin',
          zip_codes: ['55429']
      },
      "dalbo" => {
          lat: 45.658851623535156,
          lon:  -93.39884185791016,
          county: 'isanti',
          zip_codes: ['55017']
      },
      "danube" => {
          lat: 44.791900634765625,
          lon: -95.09722137451172,
          county: 'renville',
          zip_codes: ['56230']
      },
      "dassel" => {
          lat: 45.08163070678711,
          lon: -94.30693054199219,
          county: 'meeker',
          zip_codes: ['55325']
      },
      "deephaven" => {
          lat: 44.929691314697266,
          lon: -93.5224609375,
          county: 'hennepin',
          zip_codes: ['']
      },
      "deer river" => {
          lat: 47.33300018310547,
          lon: -93.79271697998047,
          county: 'itasca',
          zip_codes: ['56636']
      },
      "delano" => {
          lat: 45.041908264160156,
          lon: -93.78913116455078,
          county: 'wright',
          zip_codes: ['55328']
      },
      "detroit lakes" => {
          lat: 46.81718063354492,
          lon:  -95.84532928466797,
          county: 'becker',
          zip_codes: ['56501']
      },
      "duluth" => {
          lat: 46.78327178955078,
          lon: -92.10658264160156,
          county: 'saint louis',
          zip_codes: ['55801']
      },
      "dundas" => {
          lat: 44.4294359,
          lon:  -93.2020856,
          county: 'rice',
          zip_codes: ['55019']
      },
      "eagan" => {
          lat: 44.80413055419922,
          lon: -93.1668930053711,
          county: 'dakota',
          zip_codes: ['55121']
      },
      "east bethel" => {
          lat: 45.31940841674805,
          lon: -93.20245361328125,
          county: 'anoka',
          zip_codes: ['55005']
      },
      "eden prairie" => {
          lat: 44.85469055175781,
          lon: -93.47078704833984,
          county: 'hennepin',
          zip_codes: ['55344']
      },
      "edina" => {
          lat: 44.8897027,
          lon: -93.3501222,
          county: 'hennepin',
          zip_codes: ['55424']
      },
      "elk river" => {
          lat: 45.30384826660156,
          lon: -93.56717681884766,
          county: 'sherburne',
          zip_codes: ['53330']
      },
      "ely" => {
          lat: 47.90324020385742,
          lon: -91.8670883178711,
          county: 'saint louis',
          zip_codes: ['55731']
      },
      "elysian" => {
          lat: 44.19858169555664,
          lon: -93.67384338378906,
          county: 'le sueur',
          zip_codes: ['56028']
      },
      "embarrass" => {
          lat: 47.659088134765625,
          lon: -92.19795227050781,
          county: 'saint louis',
          zip_codes: ['55732']
      },
      "esko" => {
          lat: 46.705780029296875,
          lon: -92.36325073242188,
          county: 'carlton',
          zip_codes: ['55733']
      },
      "eveleth" => {
          lat: 47.46242904663086,
          lon: -92.53990936279297,
          county: 'saint louis',
          zip_codes: ['55734']
      },
      "excelsior" => {
          lat: 44.90330123901367,
          lon: -93.56635284423828,
          county: 'hennepin',
          zip_codes: ['55331']
      },
      "eyota" => {
          lat: 43.98830032348633,
          lon: -92.22850036621094,
          county: 'olmsted',
          zip_codes: ['55934']
      },
      "fairfax" => {
          lat: 44.52912902832031,
          lon:  -94.72081756591797,
          county: 'renville',
          zip_codes: ['55332']
      },
      "fairmont" => {
          lat: 43.65217971801758,
          lon: -94.4610824584961,
          county: 'martin',
          zip_codes: ['56031']
      },
      "falcon heights" => {
          lat: 44.99163055419922,
          lon:  -93.16632843017578,
          county: 'ramsey',
          zip_codes: ['55108']
      },
      "faribault" => {
          lat: 44.294960021972656,
          lon: -93.26882934570312,
          county: 'rice',
          zip_codes: ['55021']
      },
      "farmington" => {
          lat: 44.64023971557617,
          lon:  -93.14354705810547,
          county: 'dakota',
          zip_codes: ['55024']
      },
      "farwell" => {
          lat:  45.75217819213867,
          lon: -95.61727142333984,
          county: 'pope',
          zip_codes: ['56327']
      },
      "fergus falls" => {
          lat: 46.28302001953125,
          lon:  -96.07756042480469,
          county: 'otter tail',
          zip_codes: ['56537']
      },
      "finland" => {
          lat: 47.41463851928711,
          lon:  -91.24904632568360,
          county: 'lake',
          zip_codes: ['55603']
      },
      "florence" => {
          lat: 44.2371877,
          lon: -96.0519726,
          county: 'lyon',
          zip_codes: ['']
      },
      "foley" => {
          lat: 45.663512000000004,
          lon:  -93.91372770000001,
          county: 'benton',
          zip_codes: ['56329']
      },
      "forest lake" => {
          lat: 45.27885818481445,
          lon: -92.98522186279297,
          county: 'washington',
          zip_codes: ['55025']
      },
      "franklin" => {
          lat: 44.528289794921875,
          lon:  -94.88054656982422,
          county: 'renville',
          zip_codes: ['55333']
      },
      "frazee" => {
          lat: 46.72800827026367,
          lon: -95.70088195800781,
          county: 'becker',
          zip_codes: ['56544']
      },
      "fridley" => {
          lat: 45.08607864379883,
          lon:  -93.2632827758789,
          county: 'anoka',
          zip_codes: ['55432']
      },
      "frost" => {
          lat: 43.586341857910156,
          lon: -93.926620483398440,
          county: 'faribault',
          zip_codes: ['56033']
      },
      "fulda" => {
          lat: 43.870521545410156,
          lon: -95.60028839111328,
          county: 'murray',
          zip_codes: ['56131']
      },
      "gheen" => {
          lat: 47.964080810546875,
          lon: -92.82906341552734,
          county: 'saint louis',
          zip_codes: ['']
      },
      "gibbon" => {
          lat: 44.533851623535156,
          lon: -94.5263671875,
          county: 'sibley',
          zip_codes: ['55335']
      },
      "gilbert" => {
          lat: 47.488819122314450,
          lon: -92.46491241455078,
          county: 'saint louis',
          zip_codes: ['55741']
      },
      "glencoe" => {
          lat: 44.76913070678711,
          lon: -94.15164184570312,
          county: 'mcleod',
          zip_codes: ['55336']
      },
      "glenwood" => {
          lat: 45.65024185180664,
          lon: -95.38976287841797,
          county: 'pope',
          zip_codes: ['56334']
      },
      "golden valley" => {
          lat: 45.00968933105469,
          lon:  -93.34912109375,
          county: 'hennepin',
          zip_codes: ['55422']
      },
      "good thunder" => {
          lat: 44.00468826293945,
          lon: -94.06578826904297,
          county: 'blue earth',
          zip_codes: ['56037']
      },
      "goodhue" => {
          lat: 44.40052032470703,
          lon: -92.6238021850586,
          county: 'goodhue',
          zip_codes: ['55027']
      },
      "goodview" => {
          lat: 44.062461853027344,
          lon: -91.69570922851562,
          county: 'winona',
          zip_codes: ['']
      },
      "grand marais" => {
          lat: 47.750450134277344,
          lon:  -90.33426666259766,
          county: 'cook',
          zip_codes: ['55604']
      },
      "grand rapids" => {
          lat: 47.237166,
          lon: -93.530214,
          county: 'itasca',
          zip_codes: ['55730']
      },
      "granite falls" => {
          lat: 44.8099575,
          lon: -95.5455752,
          county: 'chippewa',
          zip_codes: ['56241']
      },
      "hackensack" => {
          lat: 46.930789947509766,
          lon:  -94.52055358886719,
          county: 'cass',
          zip_codes: ['56452']
      },
      "hallock" => {
          lat: 48.77442932128906,
          lon: -96.94644927978516,
          county: 'kittson',
          zip_codes: ['56728']
      },
      "ham lake" => {
          lat: 45.250240325927734,
          lon: -93.24994659423828,
          county: 'anoka',
          zip_codes: ['']
      },
      "hamel" => {
          lat: 45.04106903076172,
          lon:  -93.5255126953125,
          county: 'hennepin',
          zip_codes: ['55340']
      },
      "hammond" => {
          lat: 44.222190856933594,
          lon: -92.3735122680664,
          county: 'wabasha',
          zip_codes: ['']
      },
      "hanley falls" => {
          lat: 44.6927352,
          lon: -95.6219645,
          county: 'yellow medicine',
          zip_codes: ['56245']
      },
      "hanover" => {
          lat: 45.155799865722656,
          lon: -93.66635131835938,
          county: 'wright',
          zip_codes: ['55341']
      },
      "hanska" => {
          lat: 44.14884948730469,
          lon: -94.494140625,
          county: 'brown',
          zip_codes: ['56041']
      },
      "harris" => {
          lat: 45.58634948730469,
          lon: -92.97466278076172,
          county: 'chisago',
          zip_codes: ['55032']
      },
      "hastings" => {
          lat: 44.74330139160156,
          lon: -92.85243225097656,
          county: 'dakota',
          zip_codes: ['55033']
      },
      "hayward" => {
          lat: 43.650508880615234,
          lon: -93.24408721923828,
          county: 'freeborn',
          zip_codes: ['56043']
      },
      "hermantown" => {
          lat: 46.806888580322266,
          lon:  -92.23825073242188,
          county: 'saint louis',
          zip_codes: ['55811']
      },
      "hibbing" => {
          lat: 47.42715072631836,
          lon: -92.93769073486328,
          county: 'saint louis',
          zip_codes: ['55746']
      },
      "hokah" => {
          lat: 43.7594108581543,
          lon:  -91.34652709960938,
          county: 'houston',
          zip_codes: ['55941']
      },
      "hopkins" => {
          lat: 44.92496109008789,
          lon: -93.46273040771484,
          county: 'hennepin',
          zip_codes: ['55305']
      },
      "hovland" => {
          lat: 47.83877944946289,
          lon:  -89.97203826904297,
          county: 'cook',
          zip_codes: ['55606']
      },
      "hugo" => {
          lat: 45.159969329833984,
          lon: -92.99327087402344,
          county: 'washington',
          zip_codes: ['55038']
      },
      "hutchinson" => {
          lat: 44.8877401,
          lon: -94.36970570000001,
          county: 'mcleod',
          zip_codes: ['55350']
      },
      "independence" => {
          lat: 45.02524185180664,
          lon: -93.70745849609375,
          county: 'hennepin',
          zip_codes: ['55359']
      },
      "international falls" => {
          lat: 48.601051330566406,
          lon: -93.41098022460938,
          county: 'koochiching',
          zip_codes: ['56649'],
          aliases: ["intl falls"]
      },
      "inver grove heights" => {
          lat: 44.848018646240234,
          lon:  -93.04271697998047,
          county: 'dakota',
          zip_codes: ['55076'],
          aliases: ["inver grove hts"]
      },
      "isanti" => {
          lat: 45.490238189697266,
          lon:  -93.24772644042969,
          county: 'isanti',
          zip_codes: ['55040']
      },
      "isle" => {
          lat: 46.13800811767578,
          lon:  -93.47078704833984,
          county: 'mille lacs',
          zip_codes: ['56342']
      },
      "janseville" => {
          lat: 44.11608123779297,
          lon: -93.70800018310547,
          county: 'waseca',
          zip_codes: ['56048']
      },
      "jeffers" => {
          lat: 44.055789947509766,
          lon: -95.19666290283203,
          county: 'cottonwood',
          zip_codes: ['56145']
      },
      "jordan" => {
          lat: 44.666908264160156,
          lon: -93.62689971923828,
          county: 'scott',
          zip_codes: ['55352']
      },
      "kasota" => {
          lat: 44.2924690246582,
          lon:  -93.96495819091797,
          county: 'la sueur',
          zip_codes: ['56050']
      },
      "kasson" => {
          lat: 44.02996063232422,
          lon: -92.75074005126953,
          county: 'dodge',
          zip_codes: ['55944']
      },
      "keewatin" => {
          lat: 47.399658203125,
          lon: -93.07241821289062,
          county: 'itasca',
          zip_codes: ['55753']
      },
      "kenyon" => {
          lat: 44.27219009399414,
          lon: -92.98548126220703,
          county: 'goodhue',
          zip_codes: ['55946']
      },
      "knife river" => {
          lat: 46.949378967285156,
          lon: -91.77906799316406,
          county: 'lake',
          zip_codes: ['55609']
      },
      "la crescent" => {
          lat: 43.82801818847656,
          lon: -91.30403137207031,
          county: 'houston',
          zip_codes: ['55947'],
          aliases: ["lacrescent"]
      },
      "lafayette" => {
          lat: 44.44662857055664,
          lon: -94.39524841308594,
          county: 'nicollet',
          zip_codes: ['56054']
      },
      "lake city" => {
          lat: 44.44968032836914,
          lon: -92.26820373535156,
          county: 'wabasha',
          zip_codes: ['55041']
      },
      "lake crystal" => {
          lat: 44.10580062866211,
          lon: -94.2188491821289,
          county: 'blue earth',
          zip_codes: ['56055']
      },
      "lake elmo" => {
          lat: 44.99580001831055,
          lon:  -92.87937927246094,
          county: 'washington',
          zip_codes: ['55042']
      },
      "lakeland" => {
          lat: 44.95635986328125,
          lon:  -92.76576232910156,
          county: 'washington',
          zip_codes: ['55043']
      },
      "lakeland shores" => {
          lat: 44.948020935058594,
          lon:  -92.76409149169922,
          county: 'washington',
          zip_codes: ['']
      },
      "lakeville" => {
          lat: 44.649688720703125,
          lon: -93.24272155761719,
          county: 'dakota',
          zip_codes: ['55044']
      },
      "laporte" => {
          lat: 47.21384048461914,
          lon: -94.7541732788086,
          county: 'hubbard',
          zip_codes: ['56461']
      },
      "lauderdale" => {
          lat: 44.99858093261719,
          lon: -93.20578002929688,
          county: 'ramsey',
          zip_codes: ['']
      },
      "le sueur" => {
          lat: 44.46134948730469,
          lon: -93.91523742675781,
          county: 'la sueur',
          zip_codes: ['56058']
      },
      "lilydale" => {
          lat: 44.916080474853516,
          lon:  -93.12605285644531,
          county: 'dakota',
          zip_codes: ['']
      },
      "lindstrom" => {
          lat: 45.389408111572266,
          lon: -92.84799194335938,
          county: 'chisago',
          zip_codes: ['55045']
      },
      "lino lakes" => {
          lat: 45.160240173339844,
          lon:  -93.08882904052734,
          county: 'anoka',
          zip_codes: ['']
      },
      "litchfield" => {
          lat: 45.12717819213867,
          lon: -94.5280532836914,
          county: 'meeker',
          zip_codes: ['55355']
      },
      "little canada" => {
          lat: 45.02690887451172,
          lon:  -93.08772277832031,
          county: 'ramsey',
          zip_codes: ['']
      },
      "little falls" => {
          lat: 45.9763545,
          lon: -94.36250240000001,
          county: 'morrison',
          zip_codes: ['56345']
      },
      "long lake" => {
          lat: 44.986629486083984,
          lon: -93.57161712646484,
          county: 'hennepin',
          zip_codes: ['55356']
      },
      "long prairie" => {
          lat: 45.97468948364258,
          lon: -94.8655776977539,
          county: 'todd',
          zip_codes: ['56347']
      },
      "longville" => {
          lat: 46.9863395690918,
          lon: -94.21135711669922,
          county: 'cass',
          zip_codes: ['56655']
      },
      "lonsdale" => {
          lat: 44.48023986816406,
          lon:  -93.42855834960938,
          county: 'rice',
          zip_codes: ['55046']
      },
      "loretto" => {
          lat: 45.054691314697266,
          lon: -93.6355209350586,
          county: 'hennepin',
          zip_codes: ['55357']
      },
      "lutsen" => {
          lat: 47.64712142944336,
          lon: -90.67485809326172,
          county: 'cook',
          zip_codes: ['55612']
      },
      "luverne" => {
          lat: 43.65414047241211,
          lon:  -96.21280670166016,
          county: 'rock',
          zip_codes: ['56156']
      },
      "madison" => {
          lat: 45.009681701660156,
          lon: -96.19587707519531,
          county: 'lac qui parle county',
          zip_codes: ['56256']
      },
      "mahtowa" => {
          lat: 46.573829650878906,
          lon: -92.6318588256836,
          county: 'carlton',
          zip_codes: ['']
      },
      "mankato" => {
          lat: 44.1634663,
          lon: -93.9993505,
          county: 'blue earth',
          zip_codes: ['56001']
      },
      "mantorville" => {
          lat: 44.069129943847656,
          lon: -92.75575256347656,
          county: 'dodge',
          zip_codes: ['55955']
      },
      "maple grove" => {
          lat: 45.07246017456055,
          lon: -93.4557876586914,
          county: 'hennepin',
          zip_codes: ['55311']
      },
      "maple plain" => {
          lat: 45.0071907043457,
          lon: -93.65579223632812,
          county: 'hennepin',
          zip_codes: ['55348']
      },
      "maplewood" => {
          lat: 44.95301818847656,
          lon: -92.9952163696289,
          county: 'ramsey',
          zip_codes: ['55109']
      },
      # alias: marine on saint croix, saint croux, st. croix
      "marine on st croix" => {
          lat: 45.19805908203125,
          lon: -92.77111053466797,
          county: 'washington',
          zip_codes: ['55047']
      },
      "marshall" => {
          lat: 44.4468994140625,
          lon:  -95.78835296630860,
          county: 'lyon',
          zip_codes: ['56258']
      },
      "mayer" => {
          lat: 44.88496017456055,
          lon: -93.88774871826172,
          county: 'carver',
          zip_codes: ['55360']
      },
      "melrose" => {
          lat: 45.67469024658203,
          lon:  -94.8075180053711,
          county: 'stearns',
          zip_codes: ['56352']
      },
      "menahga" => {
          lat: 46.753849029541016,
          lon: -95.09808349609375,
          county: 'wadena',
          zip_codes: ['56464']
      },
      "mendota heights" => {
          lat: 44.88357925415039,
          lon:  -93.13826751708984,
          county: 'dakota',
          zip_codes: ['55120']
      },
      "mentor" => {
          lat: 47.698299407958984,
          lon: -96.14115905761719,
          county: 'polk',
          zip_codes: ['56736']
      },
      "milaca" => {
          lat: 45.75579833984375,
          lon: -93.65441131591797,
          county: 'mille lacs county',
          zip_codes: ['56353']
      },
      "miltona" => {
          lat: 46.04412841796875,
          lon: -95.29141998291016,
          county: 'douglas',
          zip_codes: ['56354']
      },
      "minneapolis" => {
          lat: 44.9799690246582,
          lon: -93.26383972167969,
          county: 'hennepin',
          zip_codes: ['55401'],
          aliases: %w{minneaapolis, minneaplis, minneapolsi, minnneapolis, mpls}
      },
      "minnesota city" => {
          lat: 44.093849182128906,
          lon: -91.74960327148438,
          county: 'winona',
          zip_codes: ['55959']
      },
      "minnetonka" => {
          lat: 44.913299560546875,
          lon: -93.50328826904297,
          county: 'hennepin',
          zip_codes: ['55305'],
          aliases: ["minnnetonka"]
      },
      "minnetrista" => {
          lat: 44.93830108642578,
          lon: -93.71774291992188,
          county: 'hennepin',
          zip_codes: ['']
      },
      "montevideo" => {
          lat: 44.948028564453125,
          lon: -95.71701049804688,
          county: 'chippewa',
          zip_codes: ['56265']
      },
      "montgomery" => {
          lat: 44.438850402832030,
          lon: -93.58133697509766,
          county: 'le sueur',
          zip_codes: ['56069']
      },
      "monticello" => {
          lat: 45.305519104003906,
          lon: -93.79414367675781,
          county: 'wright',
          zip_codes: ['55362']
      },
      "montrose" => {
          lat: 45.06496047973633,
          lon: -93.91107940673828,
          county: 'wright',
          zip_codes: ['55363']
      },
      "moorhead" => {
          lat: 46.87385940551758,
          lon: -96.7695083618164,
          county: 'clay',
          zip_codes: ['56560']
      },
      "moose lake" => {
          lat: 46.454109191894530,
          lon: -92.76187133789062,
          county: 'carlton',
          zip_codes: ['55767']
      },
      "mora" => {
          lat: 45.8769031,
          lon:  -93.2938352,
          county: 'kanabec',
          zip_codes: ['55051']
      },
      "morris" => {
          lat: 45.5860710144043,
          lon:  -95.9139404296875,
          county: 'stevens',
          zip_codes: ['56267']
      },
      "motley" => {
          lat: 46.336631774902344,
          lon: -94.6461181640625,
          county: 'morrison',
          zip_codes: ['56466']
      },
      "mound" => {
          lat: 44.93663024902344,
          lon:  -93.66606903076172,
          county: 'hennepin',
          zip_codes: ['55364']
      },
      "mounds view" => {
          lat: 45.1049690246582,
          lon:  -93.20855712890625,
          county: 'ramsey',
          zip_codes: ['']
      },
      "mountain lake" => {
          lat: 43.93885040283203,
          lon: -94.9297103881836,
          county: 'cottonwood',
          zip_codes: ['56159']
      },
      "murdock" => {
          lat: 45.22385025024414,
          lon: -95.39335632324219,
          county: 'swift',
          zip_codes: ['56271']
      },
      "nerstrand" => {
          lat: 44.34191131591797,
          lon: -93.0679931640625,
          county: 'rice',
          zip_codes: ['55053']
      },
      "new brighton" => {
          lat: 45.065521240234375,
          lon: -93.20188903808594,
          county: 'ramsey',
          zip_codes: ['55112']
      },
      "new germany" => {
          lat: 44.88412857055664,
          lon:  -93.97052764892578,
          county: 'carver',
          zip_codes: ['55367']
      },
      "new hope" => {
          lat: 45.038021087646484,
          lon: -93.3866195678711,
          county: 'hennepin',
          zip_codes: ['55428']
      },
      "new london" => {
          lat: 45.30107879638672,
          lon: -94.944183349609380,
          county: 'kandiyohi',
          zip_codes: ['56273']
      },
      "new richland" => {
          lat: 43.89384841918945,
          lon:  -93.49382781982422,
          county: 'waseca',
          zip_codes: ['56072']
      },
      "new ulm" => {
          lat: 44.312461853027344,
          lon: -94.46053314208984,
          county: 'brown',
          zip_codes: ['56073']
      },
      "new york mills" => {
          lat: 46.5180469,
          lon: -95.3763155,
          county: 'otter tail county',
          zip_codes: ['56567']
      },
      "newport" => {
          lat: 44.86635971069336,
          lon: -93.00048828125,
          county: 'washington',
          zip_codes: ['550555']
      },
      "nicollet" => {
          lat: 44.27608108520508,
          lon: -94.18746185302734,
          county: 'nicollet',
          zip_codes: ['56074']
      },
      "nisswa" => {
          lat: 46.5205192565918,
          lon: -94.28861236572266,
          county: 'crow wing',
          zip_codes: ['56468']
      },
      "north branch" => {
          lat: 45.511348724365234,
          lon: -92.98021697998047,
          county: 'chisago',
          zip_codes: ['55056']
      },
      "north mankato" => {
          lat: 44.1732996,
          lon: -94.03384510000001,
          county: 'nicollet',
          zip_codes: ['']
      },
      "north st paul" => {
          lat: 45.01247024536133,
          lon: -92.99188232421875,
          county: 'ramsey',
          zip_codes: ['']
      },
      "northfield" => {
          lat: 44.4582041,
          lon: -93.16115900000001,
          county: 'rice',
          zip_codes: ['55057']
      },
      "northome" => {
          lat: 47.872456,
          lon: -94.28050300000001,
          county: 'koochiching',
          zip_codes: ['56661']
      },
      "norwood" => {
          lat: 44.7735710144043,
          lon: -93.921630859375,
          county: 'carver',
          zip_codes: ['55368']
      },
      "oak park heights" => {
          lat: 45.0313606262207,
          lon: -92.79297637939453,
          county: 'washington',
          zip_codes: ['']
      },
      "oakdale" => {
          lat: 44.96302032470703,
          lon: -92.9649429321289,
          county: 'washington',
          zip_codes: ['55083']
      },
      "ogilvie" => {
          lat: 45.83218002319336,
          lon:  -93.42633819580078,
          county: 'kanabec',
          zip_codes: ['56358']
      },
      "onamia" => {
          lat: 46.0705151,
          lon:  -93.66774550000001,
          county: 'mille lacs',
          zip_codes: ['56359']
      },
      "ortonville" => {
          lat: 45.304691314697266,
          lon: -96.44477844238281,
          county: 'big stone',
          zip_codes: ['56728']
      },
      "osseo" => {
          lat: 45.11941146850586,
          lon: -93.40245056152344,
          county: 'hennepin',
          zip_codes: ['55369']
      },
      "ottertail" => {
          lat: 46.42552185058594,
          lon: -95.55725860595703,
          county: 'otter tail',
          zip_codes: ['56571']
      },
      "park rapids" => {
          lat: 46.922181300000005,
          lon: -95.0586322,
          county: 'hubbard',
          zip_codes: ['56470']
      },
      "pelican rapids" => {
          lat: 46.570792000000004,
          lon: -96.083112,
          county: 'otter tail',
          zip_codes: ['56572']
      },
      "pequot lakes" => {
          lat: 46.60301971435547,
          lon: -94.30944061279297,
          county: 'crow wing',
          zip_codes: ['56472']
      },
      "perham" => {
          lat:  46.5944042,
          lon: 95.5725415,
          county: 'otter tail',
          zip_codes: ['56572']
      },
      "pillager" => {
          lat: 46.32997131347656,
          lon: -94.47416687011719,
          county: 'cass',
          zip_codes: ['56473']
      },
      "pine city" => {
          lat: 45.82606887817383,
          lon: -92.96853637695312,
          county: 'pine',
          zip_codes: ['55063']
      },
      "pine island" => {
          lat: 44.201351165771484,
          lon: -92.64630126953125,
          county: 'goodhue',
          zip_codes: ['55963']
      },
      "pine river" => {
          lat: 46.718021392822266,
          lon: -94.40415954589844,
          county: 'cass',
          zip_codes: ['56474']
      },
      "pipestone" => {
          lat: 44.00053024291992,
          lon: -96.3175277709961,
          county: 'pipestone',
          zip_codes: ['56164']
      },
      "plymouth" => {
          lat: 45.010520935058594,
          lon:  -93.45551300048828,
          county: 'hennepin',
          zip_codes: ['55392']
      },
      "preston" => {
          lat: 43.67023849487305,
          lon: -92.08322143554688,
          county: 'fillmore',
          zip_codes: ['55965']
      },
      "princeton" => {
          lat: 45.569969177246094,
          lon: -93.58162689208984,
          county: 'mille lacs',
          zip_codes: ['55371']
      },
      "prior lake" => {
          lat: 44.71329879760742,
          lon:  -93.4227294921875,
          county: 'scott',
          zip_codes: ['55372']
      },
      "proctor" => {
          lat: 46.7471638,
          lon:  -92.2254695,
          county: 'saint louis',
          zip_codes: ['']
      },
      "puposky" => {
          lat: 47.677730560302734,
          lon: -94.90721893310547,
          county: 'beltrami',
          zip_codes: ['56667']
      },
      "ramsey" => {
          lat: 45.26110076904297,
          lon:  -93.44999694824219,
          county: 'anoka',
          zip_codes: ['55303']
      },
      "randolph" => {
          lat: 44.52608108520508,
          lon: -93.01992797851562,
          county: 'dakota',
          zip_codes: ['55065']
      },
      "red wing" => {
          lat: 44.562469482421875,
          lon:  -92.53379821777344,
          county: 'goodhue',
          zip_codes: ['55066']
      },
      "rice" => {
          lat: 45.75191116333008,
          lon: -94.22026824951172,
          county: 'benton',
          zip_codes: ['56367']
      },
      "richfield" => {
          lat: 44.8766431,
          lon: -93.28778770000001,
          county: 'hennepin',
          zip_codes: ['55423']
      },
      "robbinsdale" => {
          lat: 45.031696000000004,
          lon:  -93.33531980000001,
          county: 'hennepin',
          zip_codes: ['']
      },
      "rochester" => {
          lat:  44.021629333496094,
          lon: -92.46990203857422,
          county: 'olmsted',
          zip_codes: ['55901']
      },
      "rockford" => {
          lat: 45.08829879760742,
          lon: -93.73441314697266,
          county: 'wright',
          zip_codes: ['55373']
      },
      "rogers" => {
          lat: 45.18885040283203,
          lon: -93.55300903320312,
          county: 'hennepin',
          zip_codes: ['55374']
      },
      "rosemount" => {
          lat: 44.739410400390625,
          lon: -93.12577056884766,
          county: 'dakota',
          zip_codes: ['55068']
      },
      "roseville" => {
          lat: 45.006080627441406,
          lon:  -93.15660858154297,
          county: 'ramsey',
          zip_codes: ['55113'],
          aliases: ['rosevill']
      },
      "rush city" => {
          lat: 45.685508728027344,
          lon: -92.96549224853516,
          county: 'chisago',
          zip_codes: ['55069']
      },
      "russell" => {
          lat: 44.31913,
          lon: -95.95169200000001,
          county: 'lyon',
          zip_codes: ['56169']
      },
      "saginaw" => {
          lat: 46.85911178588867,
          lon:  -92.4443588256836,
          county: 'saint louis',
          zip_codes: ['55779']
      },
      "st anthony" => {
          lat: 45.0205192565918,
          lon: -93.21800231933594,
          county: 'hennepin',
          zip_codes: ['']
      },
      "st augusta" => {
          lat: 45.478580474853516,
          lon: -94.1541519165039,
          county: 'stearns',
          zip_codes: ['']
      },
      "st bonifacius" => {
          lat: 44.905521392822266,
          lon: -93.7474594116211,
          county: 'hennepin',
          zip_codes: ['55375']
      },
      "st charles" => {
          lat: 43.96940994262695,
          lon: -92.0643310546875,
          county: 'winona',
          zip_codes: ['55972']
      },
      "st cloud" => {
          lat: 45.56079864501953,
          lon: -94.16249084472656,
          county: 'stearns',
          zip_codes: ['56301']
      },
      "st francis" => {
          lat: 45.38690948486328,
          lon: -93.3593978881836,
          county: 'anoka',
          zip_codes: ['55070']
      },
      "st joseph" => {
          lat: 45.56496047973633,
          lon: -94.31832885742188,
          county: 'stearns',
          zip_codes: ['56374']
      },
      "st louis park" => {
          lat:  44.948299407958984,
          lon: -93.34800720214844,
          county: 'hennepin',
          zip_codes: ['55416']
      },
      "st michael" => {
          lat: 45.2099609375,
          lon: -93.66496276855469,
          county: 'wright',
          zip_codes: ['55376']
      },
      "st paul" => {
          lat:  44.94440841674805,
          lon:  -93.09326934814453,
          county: 'ramsey',
          zip_codes: ['55101']
      },
      "st paul park" => {
          lat: 44.84218978881836,
          lon:  -92.99131774902344,
          county: 'washington',
          zip_codes: ['55071']
      },
      "st peter" => {
          lat: 44.32358169555664,
          lon: -93.9580078125,
          county: 'nicollet',
          zip_codes: ['56082']
      },
      "sandstone" => {
          lat: 46.13106155395508,
          lon: -92.86741638183594,
          county: 'pine',
          zip_codes: ['55072']
      },
      "sartell" => {
          lat: 45.62163162231445,
          lon: -94.20693969726562,
          county: 'stearns',
          zip_codes: ['56377']
      },
      "sauk centre" => {
          lat: 45.73746871948242,
          lon:  -94.95252227783203,
          county: 'stearns',
          zip_codes: ['56378']
      },
      "sauk rapids" => {
          lat: 45.59191131591797,
          lon: -94.16609954833984,
          county: 'benton',
          zip_codes: ['56379']
      },
      "savage" => {
          lat: 44.77912902832031,
          lon:  -93.33634185791016,
          county: 'scott',
          zip_codes: ['55378']
      },
      "scandia" => {
          lat: 0,
          lon: 0,
          county: '',
          zip_codes: ['']
      },
      "sedan" => {
          lat: 45.57551956176758,
          lon: -95.24807739257812,
          county: 'pope',
          zip_codes: ['']
      },
      "shakopee" => {
          lat: 44.79801940917969,
          lon:  -93.52690124511719,
          county: 'scott',
          zip_codes: ['55379']
      },
      "sherburn" => {
          lat: 43.65217971801758,
          lon: -94.72692108154297,
          county: 'martin',
          zip_codes: ['56171']
      },
      "shoreview" => {
          lat: 45.07912826538086,
          lon:  -93.14717102050781,
          county: 'ramsey',
          zip_codes: ['55126']
      },
      "silver bay" => {
          lat: 47.29436111450195,
          lon: -91.25739288330078,
          county: 'lake',
          zip_codes: ['55614']
      },
      "slayton" => {
          lat: 43.98773956298828,
          lon: -95.75585174560547,
          county: 'murray',
          zip_codes: ['56172']
      },
      "sleepy eye" => {
          lat: 44.29718017578125,
          lon: -94.72415161132812,
          county: 'brown',
          zip_codes: ['56085']
      },
      "soudan" => {
          lat: 47.81575012207031,
          lon: -92.23766326904297,
          county: 'saint louis',
          zip_codes: ['55782']
      },
      "south st paul" => {
          lat: 44.892738342285156,
          lon: -93.03494262695312,
          county: 'dakota',
          zip_codes: ['55075']
      },
      "spicer" => {
          lat: 45.2330207824707,
          lon: -94.94001007080078,
          county: 'kandiyohi',
          zip_codes: ['56288']
      },
      "spring lake park" => {
          lat: 45.10773849487305,
          lon: -93.23799896240234,
          county: 'anoka',
          zip_codes: ['']
      },
      "spring valley" => {
          lat: 43.68690872192383,
          lon: -92.3890609741211,
          county: 'fillmore',
          zip_codes: ['55975']
      },
      "st anthony" => {
          lat: 45.0205192565918,
          lon: -93.21800231933594,
          county: 'hennepin',
          zip_codes: ['']
      },
      "stacy" => {
          lat: 45.39802169799805,
          lon: -92.98744201660156,
          county: 'chisago',
          zip_codes: ['55078']
      },
      "stanton" => {
          lat: 44.47190856933594,
          lon: -93.02298736572266,
          county: 'goodhue',
          zip_codes: ['']
      },
      "stewart" => {
          lat: 44.72468185424805,
          lon: -94.4858169555664,
          county: 'mcleod',
          zip_codes: ['55385']
      },
      "stewartville" => {
          lat: 43.85551834106445,
          lon: -92.48851013183594,
          county: 'olmsted',
          zip_codes: ['55976']
      },
      "stillwater" => {
          lat: 45.056358337402344,
          lon: -92.80603790283203,
          county: 'washington',
          zip_codes: ['55082']
      },
      "thief river falls" => {
          lat: 48.119140625,
          lon: -96.18115234375,
          county: 'pennington',
          zip_codes: ['56701']
      },
      "tower" => {
          lat: 47.80546951293945,
          lon:  -92.27461242675781,
          county: 'saint louis',
          zip_codes: ['55790']
      },
      "two harbors" => {
          lat: 47.025653600000005,
          lon: -91.67291820000001,
          county: 'lake',
          zip_codes: ['55616']
      },
      "upsala" => {
          lat: 45.81079864501953,
          lon:  -94.57140350341797,
          county: 'morrison',
          zip_codes: ['56384']
      },
      "vadnais heights" => {
          lat: 45.05746841430664,
          lon: -93.0738296508789,
          county: 'ramsey',
          zip_codes: ['']
      },
      "vermillion" => {
          lat: 44.673580169677734,
          lon: -92.96714782714844,
          county: 'dakota',
          zip_codes: ['55085']
      },
      "verndale" => {
          lat: 46.39830017089844,
          lon: -95.0147476196289,
          county: 'wadena',
          zip_codes: ['56481']
      },
      "victoria" => {
          lat: 44.85857009887695,
          lon: -93.66162872314453,
          county: 'carver',
          zip_codes: ['55386']
      },
      "virginia" => {
          lat: 47.523258209228516,
          lon: -92.53656768798828,
          county: 'saint louis',
          zip_codes: ['55777']
      },
      "west st paul" => {
          lat: 44.916080474853516,
          lon:  -93.10160827636719,
          county: 'dakota',
          zip_codes: ['']
      },
      "wabasha" => {
          lat: 44.38386154174805,
          lon: -92.03294372558594,
          county: 'wabasha',
          zip_codes: ['55981']
      },
      "waconia" => {
          lat: 44.850795700000006,
          lon: -93.7869088,
          county: 'carver',
          zip_codes: ['55387']
      },
      "walnut grove" => {
          lat: 44.2230110168457,
          lon: -95.46945190429688,
          county: 'redwood',
          zip_codes: ['56180']
      },
      "warba" => {
          lat: 47.12882995605469,
          lon: -93.2666015625,
          county: 'itasca',
          zip_codes: ['55793']
      },
      "warroad" => {
          lat: 48.905269622802734,
          lon: -95.31439971923828,
          county: 'roseau',
          zip_codes: ['56763']
      },
      "waseca" => {
          lat: 44.07773971557617,
          lon: -93.50743865966797,
          county: 'waseca',
          zip_codes: ['56093']
      },
      "wayzata" => {
          lat: 44.97412872314453,
          lon: -93.50662231445312,
          county: 'hennepin',
          zip_codes: ['55391']
      },
      "wells" => {
          lat: 43.746070861816406,
          lon: -93.72884368896484,
          county: 'fairibault',
          zip_codes: ['56097']
      },
      "westbrook" => {
          lat: 44.042179107666016,
          lon: -95.43611145019531,
          county: 'cottonwood',
          zip_codes: ['56183']
      },
      "white bear lake" => {
          lat: 45.08469009399414,
          lon: -93.00994110107422,
          county: 'ramsey',
          zip_codes: ['55110'],
          aliases: ["white bear township"]
      },
      "willernie" => {
          lat: 45.05413055419922,
          lon:  -92.95659637451172,
          county: 'washington',
          zip_codes: ['55090']
      },
      "willmar" => {
          lat: 45.121910095214844,
          lon: -95.04334259033203,
          county: 'kandiyohi',
          zip_codes: ['56201']
      },
      "willow river" => {
          lat: 46.31827926635742,
          lon:  -92.84130859375,
          county: 'pine',
          zip_codes: ['55795']
      },
      "windom" => {
          lat: 43.86634826660156,
          lon: -95.116943359375,
          county: 'cottonwood',
          zip_codes: ['56101']
      },
      "winona" => {
          lat: 44.04996109008789,
          lon:  -91.63932037353516,
          county: 'winona',
          zip_codes: ['55942']
      },
      "winsted" => {
          lat: 44.96384811401367,
          lon:  -94.04747009277344,
          county: 'mcleod',
          zip_codes: ['55395']
      },
      "winthrop" => {
          lat: 44.54301834106445,
          lon: -94.36637115478516,
          county: 'sibley',
          zip_codes: ['55396']
      },
      "winton" => {
          lat: 47.92628860473633,
          lon:  -91.80068969726562,
          county: 'lake',
          zip_codes: ['55796']
      },
      "woobdury" => {
          lat: 44.923858642578125,
          lon: -92.95938110351562,
          county: 'washington',
          zip_codes: ['55125'],
          aliases: ["wooddury"]
      },
      "wrenshall" => {
          lat: 46.61688995361328,
          lon: -92.38240814208984,
          county: 'carlton',
          zip_codes: ['55797']
      },
      "wykoff" => {
          lat: 43.707191467285156,
          lon: -92.26821899414062,
          county: 'fillmore',
          zip_codes: ['55990']
      },
      "wyoming" => {
          lat: 45.336355100000006,
          lon: -92.99716310000001,
          county: 'chisago',
          zip_codes: ['55092']
      },
      "zimmerman" => {
          lat: 45.44329833984375,
          lon: -93.58995819091797,
          county: 'sherburne',
          zip_codes: ['55398']
      },
      "zumbrota" => {
          lat: 44.29412841796875,
          lon:  -92.66908264160156,
          county: 'goodhue',
          zip_codes: ['55992']
      }
  }

  def self.lat_lon_for_city(city)
    if !@cities
      @cities = {}
      CITIES.each do |k, v|
        @cities[k] = v
        if v[:aliases]
          v[:aliases].each do |k2|
            @cities[k2] = v
          end
        end
      end
    end

    if m = /^(.*),/.match(city)
        city = m[1]
    end
    city = city.downcase
    city = city.gsub(/(st\.|saint)/, "st")

    info = @cities[city]
    if info
      [info[:lat], info[:lon]]
    else
      nil
    end
  end

  def self.update_lat_lon_for_member(member)
    if member.city.present?
      latitude, longitude = lat_lon_for_city(member.city)
      member.latitude = latitude
      member.longitude = longitude
    end
  end
end