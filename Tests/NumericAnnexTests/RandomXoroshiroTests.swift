import XCTest
@testable import NumericAnnex

class RandomXoroshiroTests : XCTestCase {
  func testEntropy() {
    guard let rng = Random.Xoroshiro() else {
      XCTFail()
      return
    }
    XCTAssertTrue(rng.state != (0, 0))

    let mock = {
      return nil as [UInt64]?
    }
    XCTAssertNil(Random.Xoroshiro(_entropy: mock()))
  }

  func test_1_2() {
    let rng = Random.Xoroshiro(state: (1, 2))
    // Values were generated using the reference implementation found at:
    // http://xoroshiro.di.unimi.it/xoroshiro128plus.c
    let expected: [UInt64] = [
      3,
      36029003177443331,
      78883775479546723,
      11565523463456473958,
      4242646275387589636,
      256749404433942852,
      11014892026844973196,
      9059353499452950543,
      8597521241247625872,
      4693915028112570637,
      7013278354776644264,
      7324551527405749817,
      5536070250743279847,
      14551654802141766561,
      16502220822753139053,
      9169458631996292866,
      8255063232684103966,
      4985613803055290144,
      8873762385537109026,
      7955442200162942054,
      10038983008978924840,
      16556838790008055993,
      1445216410056612069,
      11648404329028311521,
      11968528621191360117,
      378994045525309041,
      15533848123981932311,
      17810787280139321748,
      8698105432054197087,
      3039374059427402804,
      6000419305548865286,
      5555673801313513616,
      14832631808895921712,
      15269786733006210781,
      18192816199346518081,
      9227630901375587864,
      13636270006546584644,
      10048331387000224533,
      5881842723816098216,
      2759740862732559190,
      7198729811037598577,
      2536130127161171247,
      9244050483868404095,
      4471143257962844606,
      6826378813747079941,
      8311102247454864474,
      8030254548075018734,
      4856383866562462327,
      2146425163792814156,
      678709922273904935,
      14153046072826725166,
      13096693794621671407,
      3167365684852107430,
      7035944759741560501,
      4327331733683539348,
      4331384222358257785,
      11778493022454179159,
      6436799581831663489,
      5199453391521163130,
      13866358363722915963,
      10490459205808868365,
      8942744637306013108,
      13330606527360361965,
      15114450932505609455,
      10484962763089362709,
      8486043591433584489,
      1244312731768254023,
      1423652513934467700,
      7202410701832789339,
      4247336634893478223,
      2761260300685838243,
      3026641667955338198,
      11726045602658466327,
      15986288544570028551,
      1140902651811776482,
      3031375389759955929,
      10251211885453078785,
      3805832680344220010,
      6901351005802427116,
      327749723378156456,
      3850130685063866272,
      395616431473633113,
      1006002813608848610,
      13567214008324118923,
      8234626684467576068,
      12325748354848861738,
      13876857058316077328,
      5575055431371035091,
      1001747845116129793,
      1911249420570102675,
      11307478254871521778,
      11741813699519564532,
      18249690205084409006,
      4141904051068235945,
      8007541499524410059,
      11522483542545463294,
      12843807877472758944,
      4036354428928582882,
      3568160883062227481,
      7069228111761650618,
      12800820881038955908,
      12096397496417421560,
      18331638049296705373,
      14080565232358176996,
      11717911967111159659,
      5236417326714399775,
      896860817366679607,
      1103175799875588730,
      5624452808649533921,
      14074612223815901137,
      12560226745213461489,
      8693158002233621656,
      13522197534225561183,
      17543423602239517471,
      9007394771080283032,
      13751257602651261054,
      10523437980156934525,
      3939326514580989433,
      4009481458773474577,
      5605944737217646703,
      11357362020001843015,
      6496864033205151805,
      8784505647222405488,
      6539787485601627798,
      14223996719628965531,
      11820130316034487593,
      9216825067157709454,
      13450820975868246163,
      13582660326201054082,
      7274082025836619686,
      5139824568063119565,
      15809486898860438280,
      10511273953872056519,
      8550850887347653734,
      4982865717503297021,
      16768400430211288709,
      5532507867727508336,
      3461217932251647116,
      7937630382825106010,
      8428419650246743539,
      13756581925356151789,
      12850941715331890900,
      17583375651346257957,
      14212940247871282486,
      2939312478589591003,
      9113217020860214630,
      15037155367836561944,
      5106936154711971714,
      7731881123454188381,
      8800799748666791518,
      5334921694098114980,
      16976572882617606055,
      10733445809727535171,
      18071763238883705179,
      12390417336872755007,
      4675767129793818894,
      4624990676514788078,
      13985922235308181354,
      18199410361023570910,
      11100295634832328716,
      14349833775752484419,
      2635828052976710695,
      13494215123457180093,
      824431475002587115,
      16362343995287574060,
      12565374284554722892,
      3400506694682569059,
      9678328826858469760,
      2356773772080043977,
      6660327511171829851,
      7003621798856571358,
      13678900301532284938,
      10328133941778183218,
      18415851989001661946,
      164983221740675978,
      12091409703168792651,
      16023813642563214154,
      13146064085390259297,
      16830016805105752873,
      12909765344649172761,
      18132040913220627960,
      13428079187771868408,
      13253065382531928412,
      5597099400358632931,
      15048470487608189234,
      13965835027251694013,
      16488001888584899979,
      6774957755200087230,
      9420290878387669954,
      18103357232511502336,
      7958521771342382343,
      7946005055385189225,
      7459466188094139112,
      12160219491927961419,
      10303458678974273963,
      15164880279874615320,
      8229476507371032858,
      8299451873416872397,
      14240369133888159195,
      14259674009027384056,
    ]

    for (index, value) in zip(0..., rng.prefix(expected.count)) {
      XCTAssertEqual(expected[index], value)
    }
  }

  func test_42_42() {
    let rng = Random.Xoroshiro(state: (42, 42))
    // Values were generated using the reference implementation found at:
    // http://xoroshiro.di.unimi.it/xoroshiro128plus.c
    let expected: [UInt64] = [
      84,
      1513209474796486656,
      1516164967689093120,
      13042513867470012437,
      12360923703050654741,
      1540629971893098580,
      16526710497398440032,
      6385704233003790657,
      11168422736538991365,
      4445263159897632708,
      3623790067483698302,
      16679083957109345764,
      2328362623729376304,
      11959586146887887947,
      1397979073127807009,
      2057082927736384432,
      9405332975393492225,
      8930172824755803710,
      15806946208844633572,
      13763125990787205877,
      3588104897035227753,
      16535253711858701559,
      1756777986788515775,
      3260086412739166738,
      2968118814995357638,
      10401021566468687067,
      10396793383754549895,
      7751583068336470633,
      18199822703658045417,
      18106278619996331558,
      11555865454533205083,
      11019066312200696059,
      14691523452735343350,
      8374833488214025190,
      5144857991660071778,
      4303754754246322002,
      7833483779443332279,
      9537057695470270940,
      15360815301067540763,
      8680872279790622784,
      5061961432584221634,
      13845413006391880255,
      9347406936646547437,
      9936035123032424105,
      7762742561483885717,
      6225100736029176021,
      12384612707518261907,
      6932426897081241028,
      12622735902618443507,
      16497181272706281681,
      4175144421792863622,
      7187519007501887217,
      1296625689586954249,
      9756008725656319610,
      13415925134280955255,
      7869611265653995342,
      15802320767156340368,
      9917057770149375021,
      6602199518275499834,
      15985761826175804236,
      6348789404701085358,
      13882066392163471251,
      6823376289545817014,
      2440555314667442152,
      8120581271152580867,
      5962305562057075398,
      8624786735003738880,
      17278456019734296413,
      8810594517455747061,
      3308252836812617218,
      11509046657648993076,
      4526424802255960286,
      11368279899573388309,
      17164649625755550542,
      17756655439803178301,
      1790544258914355261,
      16936001771718971059,
      6604464130005614382,
      4599098751468689332,
      5595709687219398019,
      7782673445638093156,
      11625849522136425098,
      17545728945788535376,
      1086103391208514655,
      6757121107432662022,
      7110671459349670034,
      14243248346778391217,
      6293180738376339946,
      82698844051683738,
      9016754545624797992,
      12686910675574395757,
      11377577519711600987,
      2421687222153439150,
      5062679022650701181,
      5366991913210349668,
      17763749207842542169,
      15150310935153524353,
      8753573200416713058,
      14717915573524068736,
      4976419370494142329,
      15950649534319229916,
      14729183728516038958,
      14130494893011053825,
      484607939216453498,
      11916622920760767819,
      6235630645739181768,
      3311677611128604917,
      15387119495745197491,
      18407483842959607091,
      13443654906141944091,
      7336989792155624100,
      4969837398812759230,
      4690320617290695452,
      7922943443598648642,
      7261933739777886868,
      1428233557480945068,
      13405045269283977471,
      8264480103292844317,
      3636005412915626226,
      14531131283728793534,
      1554317509710298241,
      5671084098303337046,
      2329626881373043482,
      9843173781615930848,
      11631854473490224468,
      1971235111135032481,
      16500865010222116014,
      15716915215378368203,
      9800201135256065410,
      15826078301157734671,
      8086394309479137252,
      4024335468016869419,
      9607553477750614063,
      8476344891763358613,
      9598206907093120703,
      2222640063630506567,
      4748064424880786781,
      16133608208331438329,
      4841284499098320283,
      14366219220792192136,
      12340209151804320950,
      9394640533303495521,
      9967177845151229775,
      1422411866393454331,
      1700294099603155803,
      3169743091038458854,
      1730162735865459074,
      7076023242537824502,
      9751492838437846300,
      5563389164091569554,
      14685081858851293124,
      17127988883180719048,
      13139712666856391346,
      16133760556311029769,
      16124042929298679518,
      15244317750072181250,
      16865140868997569773,
      3382895046112672233,
      3311493913432858434,
      6972003746672027210,
      10860730320333834349,
      13157555520059317901,
      18049794823806643433,
      4096188303889068959,
      5848535283123888736,
      14097084481779687678,
      5923531794703750167,
      8671735658329475473,
      12796338774024443025,
      17688950762314547996,
      17545970295496335826,
      18087282577194630790,
      6111642868515581430,
      9663837423353030300,
      5519877375598539571,
      198283696489934212,
      639923763610710485,
      9642279419743806424,
      12740328497763347702,
      5689966802246858055,
      2542424879537644225,
      4148468791004988526,
      15776468824412039713,
      9064289572460882470,
      8024516222176589607,
      13357280224400389184,
      6416386861523146761,
      2944019619063193966,
      15840065439036381038,
      8319915330237311105,
      12425399842755045103,
      11362128272172250003,
      7666439957252188840,
      17584644503297617903,
      18199845540565038844,
      16892202086104407413,
      11581668723621517396,
      7063743100798932176,
      16723393516470594016,
      15389111121968225194,
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
