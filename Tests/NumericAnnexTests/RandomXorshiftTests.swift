import XCTest
@testable import NumericAnnex

class RandomXorshiftTests : XCTestCase {
  func testEntropy() {
    guard let rng = Random() else {
      XCTFail()
      return
    }
    XCTAssertTrue(rng.state != (0, 0))

    let mock = {
      return nil as [UInt64]?
    }
    XCTAssertNil(Random(_entropy: mock()))
  }

  func test_1_2() {
    let rng = Random(state: (1, 2))
    // Values were generated using the reference implementation found at:
    // http://xoroshiro.di.unimi.it/xorshift128plus.c
    let expected: [UInt64] = [
      3,
      8388645,
      33816707,
      70368778527840,
      211106267172129,
      281552312399723,
      352084508939685,
      648800200157934532,
      2540241598295339419,
      2648407162339308712,
      2668752799858137237,
      2693699070923777171,
      4963962142036894822,
      11906738374415673757,
      9632391838565739090,
      2066554175270807792,
      2494022894752328945,
      1356498747469623086,
      11211414770921777427,
      10429009827004399351,
      2323958476090753392,
      3568022355029630745,
      66653323867787511,
      2202670577644624798,
      12857773250674142713,
      4201717447333134628,
      15638699059651815979,
      4364251867564744889,
      7660026492187243788,
      3800851612386782149,
      9605385339319476694,
      2406190703679268226,
      846469172938628641,
      5337113899023465296,
      15781852488115071549,
      15354462637857246627,
      11103786004116532909,
      10104343325409002424,
      12295544783831320534,
      9091324406814034890,
      6628842478985115447,
      12899089858988772368,
      16555193421103270775,
      5182223508147526313,
      1789523054416386623,
      8305247958687497212,
      4332901280696262112,
      4830599505179982300,
      16562699778378001540,
      4301002138587088699,
      16887648884050224867,
      8961088417938801842,
      18120357346625319699,
      5062957422512203146,
      14533691471387576319,
      17893283120539033726,
      8933729491225170482,
      7703252517382402300,
      4527677543428710360,
      11852647525519638421,
      14323485818621793660,
      1603981125980772416,
      10667357879029765177,
      12618821681808242380,
      15688459637854892994,
      16858336139413885781,
      8192223518607711332,
      15086078044025798325,
      7820396459134496922,
      10260666624710253760,
      12864353747813168684,
      3349112384258896183,
      17079950137619159659,
      13693940288920244054,
      4120914027243693443,
      16513947166147576873,
      7753202820822651981,
      6626804775540638270,
      6691531028144752467,
      1848899687106318854,
      13681393795236538282,
      16157808923290844879,
      14402137377069136975,
      10721861038970349125,
      11713871874537672148,
      17636397933591539986,
      4203420467318374,
      14279516174659940213,
      5030216290135979793,
      12431123221355774434,
      3353451983739559286,
      1982730773867159337,
      4287093158672282079,
      10427894759339841969,
      10992708284980487886,
      9826778016246262346,
      598098170064759435,
      5132675295537973900,
      2977953682469803199,
      7095603002820811521,
      14473363250705030589,
      5815164147694210911,
      893364492343289163,
      7223131833749622824,
      8283693734360236205,
      18098811217686597526,
      13472185143670172098,
      4921989762323275340,
      1122032220579367383,
      1580787425287478212,
      12971777770367737930,
      14141602702208488443,
      8934944843784058286,
      6607626240826326523,
      6849503334803588545,
      8945087483095516625,
      11138928521629212103,
      17790276629890369045,
      1578334294751373582,
      2806185787680672391,
      2659421138426664381,
      5725303483961243766,
      6184936954810297634,
      939427805219677289,
      7877825174927605138,
      17042809939415329651,
      7007032053414486723,
      708948147059678574,
      5807695797323831903,
      10654984825451839699,
      658076860194383956,
      6054460744441943985,
      18125771188890900160,
      12455829269468258300,
      7801377697876303864,
      1155650389744014674,
      14837203265123196363,
      14611150480548774776,
      11295561405428659877,
      14652736317255425712,
      10357309030900164003,
      11362376726255131814,
      17481625516190528824,
      10063769529741033785,
      10070196982447573973,
      10858208953628516990,
      8316996154212129605,
      1966992145466461251,
      9534492825751960063,
      17331020003238783005,
      4055301956728939736,
      15747646385425363016,
      5713890891727580694,
      16363438003468365099,
      6059680446507887551,
      15805989924395708713,
      7701919984793556335,
      10881930014020511227,
      16418946584288169403,
      149521899493351325,
      12534253806982171802,
      11139483896115829864,
      308345381091007206,
      11578160645028040120,
      16035213593244811876,
      2483577470144144779,
      2382343175518057727,
      4467734399270823599,
      6604294351011625227,
      8344523632028305909,
      13176362180825574816,
      5057251926377527702,
      4615034777510676815,
      716527652147291657,
      2255853362627944573,
      1040521049739732381,
      8767117186808380895,
      4542310411533510448,
      17298777313319151232,
      6001563173036790655,
      6632155663823324745,
      260008012886308771,
      8125529425889733497,
      8459386663958119024,
      478351272518501156,
      16245194212119991188,
      16067636681512186800,
      13291772728582610504,
      977325433216839797,
      316583137798752960,
      16331330055435573991,
      13872944562523015302,
      14073886698853620462,
      10932979021145220513,
      9767459346543799817,
      3499076079183291818,
      16794441505776618298,
      2728580826238923060,
      9982312178378568539,
      10174783523235389589,
    ]

    for (index, value) in zip(0..., rng.prefix(expected.count)) {
      XCTAssertEqual(expected[index], value)
    }
  }

  func test_42_42() {
    let rng = Random(state: (42, 42))
    // Values were generated using the reference implementation found at:
    // http://xoroshiro.di.unimi.it/xorshift128plus.c
    let expected: [UInt64] = [
      84,
      352322923,
      363332930,
      2955487621802017,
      5910974877560714,
      5984590265422244,
      3102369235448484,
      8794055518707935431,
      11715271280642458577,
      11121097408281568494,
      11123324466519438486,
      11813657815484460077,
      15967982470865911351,
      16027149834536272202,
      14579330570455427858,
      17901094324785512346,
      7299173581280891606,
      9598572314193889241,
      6321253227128400616,
      12069832686681671119,
      8362407854952761049,
      4240112657210925663,
      8298289508193808350,
      5492533585219385488,
      3424077862959065976,
      16763914594806242130,
      1218199477047421836,
      7673362999398496465,
      5794997430478554395,
      7270864472693218401,
      6217237324811287380,
      5931838762482735489,
      2650854048920189469,
      15912113305156886344,
      12742758016124380936,
      4295159997148736665,
      377715972074097257,
      2850808977988091172,
      8491599958789257052,
      9324795365995984871,
      8211242245495735455,
      17422811286952683550,
      13418142500587507919,
      5930788801560645895,
      6741187258797332316,
      10118554851581664695,
      115595561983548771,
      8043906809085936116,
      11823913423613696098,
      14518129458877160117,
      8343257749050278180,
      13733556794904034707,
      8684565082910747967,
      3120612299320189264,
      12303575766779633627,
      12795815681716387847,
      9809457554914526522,
      8920375781289094670,
      1993124226495641609,
      1733459562229749526,
      17111289711044275575,
      17744781264274534442,
      8365870118406280068,
      3394993270264399372,
      17743599368353179843,
      10866568771989044846,
      5256627558940251261,
      1523012312127918050,
      4830133096723200725,
      15678901288667906426,
      12456461226754166128,
      11853493959818320069,
      12499595671348820672,
      1087309203085082628,
      8913015614641765480,
      7628423184432057398,
      3580904369680909773,
      803445358366289622,
      11594309456042139689,
      4033442513255026894,
      1433661196805234850,
      12192207108666652295,
      14586722686201389331,
      6181944170276831130,
      764669472652961289,
      889048737081245825,
      12138836305257926083,
      888086957463834642,
      2390515631187897836,
      2446868417045655461,
      11015187241185530986,
      10036793306822931734,
      12334486703513775025,
      5108691882609665754,
      9514819673388488194,
      2273142206574835406,
      14437507437202006078,
      3730714957717498326,
      2872726062891204564,
      3798333342152566218,
      16669861045337712380,
      13102670696856779254,
      10908263394212623530,
      10676532138494980932,
      15489857964433950539,
      7937142546638092754,
      13417642705898345692,
      13600811864162143445,
      9477162617086519863,
      10624389419236725677,
      7441007177458375221,
      16546523980542070736,
      17024880117250866739,
      18039589907068853828,
      17555160936737332920,
      7083735549926373853,
      4420365159915317578,
      16029263747729017986,
      9972633967851497325,
      7138346049748499288,
      13270188884066368590,
      9463122843754064712,
      11942301208543755374,
      2622930306965644834,
      17433830334026038459,
      8169816655638087827,
      12836491954871888680,
      14528181774076346116,
      15183710998958962615,
      4028984353527250283,
      11816946909171962632,
      4065563158656645039,
      15930560328422184085,
      10849511457716257195,
      12483535526530318894,
      11367233570755787020,
      17859411692174119294,
      1306416274365004041,
      3368018692405648683,
      2913934462501646291,
      5248772458214493708,
      1765279421221167687,
      3394064100077089893,
      3629895405441912055,
      12299657979994244302,
      16008402201086829007,
      5458106375116620038,
      16730533680684926710,
      505844743719408298,
      4843472813567170388,
      12363442002524133152,
      11170145896500987331,
      8329207398927125713,
      11036379913765865888,
      2618306290991370477,
      1741543416193582741,
      5146591056299389583,
      7865421083469608492,
      7071530335411999512,
      9836070694521579615,
      8260774949340336056,
      551175967640246701,
      2030281209927081181,
      16417504261929240858,
      14442013933768465970,
      3838236631860248808,
      16071916515461671872,
      12960610862896350943,
      5289632148835048055,
      1827674498314689410,
      10789868859655831854,
      11210908846547680913,
      13945725155205586140,
      10261895380415373153,
      4016205272160740838,
      16497458846534660898,
      9795538644692598039,
      18053416664331168520,
      3256852140039313454,
      12501759108812025258,
      7098503516961967472,
      11650064198712856478,
      1593512087519278921,
      10264399986535021899,
      3537643041203047414,
      5650861041254369406,
      15204856943036229121,
      14012199752722101339,
      9164702022019181819,
      17759817422978365807,
      9543001839860678976,
      11899169602608869168,
      1442073933760388807,
      11121798007280630550,
      6079263746152188428,
      11994280689457877647,
      7959160577587456781,
      2831973816179963895,
      309986269562773395,
      6500631040839990712,
    ]

    for (index, value) in zip(0..., rng.prefix(expected.count)) {
      XCTAssertEqual(expected[index], value)
    }
  }

  static var allTests = [
    ("testEntropy", testEntropy),
    ("test_1_2", test_1_2),
    ("test_42_42", test_42_42),
  ]
}
