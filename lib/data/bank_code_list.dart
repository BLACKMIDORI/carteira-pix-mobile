/// Map for all brazilian banks.
/// Map<BankCode,BankName>
const bankCodeMap = {
  "1": "BANCO DO BRASIL S.A (BB)",
  "3": "BANCO DA AMAZONIA S.A",
  "4": "BANCO DO NORDESTE DO BRASIL S.A.",
  "7": "BNDES (Banco Nacional do Desenvolvimento Social)",
  "10": "CREDICOAMO",
  "11": "C.SUISSE HEDGING-GRIFFO CV S.A (Credit Suisse)",
  "12": "BANCO INBURSA",
  "14": "NATIXIS BRASIL S.A",
  "15": "UBS BRASIL CCTVM S.A",
  "16": "CCM DESP TRÂNS SC E RS",
  "17": "BNY MELLON BANCO S.A",
  "18": "BANCO TRICURY S.A",
  "21": "BANCO BANESTES S.A",
  "24": "BCO BANDEPE S.A",
  "25": "BANCO ALFA S.A.",
  "29": "BANCO ITAÚ CONSIGNADO S.A",
  "33": "BANCO SANTANDER BRASIL S.A",
  "36": "BANCO BBI S.A",
  "37": "BANCO DO ESTADO DO PARÁ S.A",
  "40": "BANCO CARGILL S.A",
  "41": "BANRISUL – BANCO DO ESTADO DO RIO GRANDE DO SUL S.A",
  "47": "BANCO BCO DO ESTADO DE SERGIPE S.A",
  "60": "CONFIDENCE CC S.A",
  "62": "HIPERCARD BM S.A",
  "63": "BANCO BRADESCARD",
  "64": "GOLDMAN SACHS DO BRASIL BM S.A",
  "65": "BANCO ANDBANK S.A",
  "66": "BANCO MORGAN STANLEY S.A",
  "69": "BANCO CREFISA S.A",
  "70": "BANCO DE BRASÍLIA (BRB)",
  "74": "BCO. J.SAFRA S.A",
  "75": "BCO ABN AMRO S.A",
  "76": "BANCO KDB BRASIL S.A.",
  "77": "BANCO INTER S.A",
  "78": "HAITONG BI DO BRASIL S.A",
  "79": "BANCO ORIGINAL DO AGRONEGÓCIO S.A",
  "80": "B&T CC LTDA",
  "81": "BBN BANCO BRASILEIRO DE NEGOCIOS S.A",
  "82": "BANCO TOPÁZIO S.A",
  "83": "BANCO DA CHINA BRASIL S.A",
  "84": "UNIPRIME NORTE DO PARANÁ",
  "85": "COOP CENTRAL AILOS",
  "89": "CCR REG MOGIANA",
  "91": "UNICRED CENTRAL RS",
  "92": "BRK S.A",
  "93": "PÓLOCRED SCMEPP LTDA",
  "94": "BANCO FINAXIS",
  "95": "BANCO CONFIDENCE DE CÂMBIO S.A",
  "96": "BANCO B3 S.A",
  "97": "CCC NOROESTE BRASILEIRO LTDA",
  "98": "CREDIALIANÇA CCR",
  "99": "UNIPRIME CENTRAL CCC LTDA",
  "100": "PLANNER CORRETORA DE VALORES S.A",
  "101": "RENASCENCA DTVM LTDA",
  "102": "XP INVESTIMENTOS S.A",
  "104": "CAIXA ECONÔMICA FEDERAL (CEF)",
  "105": "LECCA CFI S.A",
  "107": "BANCO BOCOM BBM S.A",
  "108": "PORTOCRED S.A",
  "111": "BANCO OLIVEIRA TRUST DTVM S.A",
  "113": "MAGLIANO S.A",
  "114": "CENTRAL COOPERATIVA DE CRÉDITO NO ESTADO DO ESPÍRITO SANTO",
  "117": "ADVANCED CC LTDA",
  "118": "STANDARD CHARTERED BI S.A",
  "119": "BANCO WESTERN UNION",
  "120": "BANCO RODOBENS S.A",
  "121": "BANCO AGIBANK S.A",
  "122": "BANCO BRADESCO BERJ S.A",
  "124": "BANCO WOORI BANK DO BRASIL S.A",
  "125": "BRASIL PLURAL S.A BANCO",
  "126": "BR PARTNERS BI",
  "127": "CODEPE CVC S.A",
  "128": "MS BANK S.A BANCO DE CÂMBIO",
  "129": "UBS BRASIL BI S.A",
  "130": "CARUANA SCFI",
  "131": "TULLETT PREBON BRASIL CVC LTDA",
  "132": "ICBC DO BRASIL BM S.A",
  "133": "CRESOL CONFEDERAÇÃO",
  "134": "BGC LIQUIDEZ DTVM LTDA",
  "136": "UNICRED COOPERATIVA",
  "137": "MULTIMONEY CC LTDA",
  "138": "GET MONEY CC LTDA",
  "139": "INTESA SANPAOLO BRASIL S.A",
  "140": "EASYNVEST - TÍTULO CV S.A",
  "142": "BROKER BRASIL CC LTDA",
  "143": "TREVISO CC S.A",
  "144": "BEXS BANCO DE CAMBIO S.A.",
  "145": "LEVYCAM CCV LTDA",
  "146": "GUITTA CC LTDA",
  "149": "FACTA S.A. CFI",
  "157": "ICAP DO BRASIL CTVM LTDA",
  "159": "CASA CREDITO S.A",
  "163": "COMMERZBANK BRASIL S.A BANCO MÚLTIPLO",
  "169": "BANCO OLÉ BONSUCESSO CONSIGNADO S.A",
  "172": "ALBATROSS CCV S.A",
  "173": "BRL TRUST DTVM SA",
  "174": "PERNAMBUCANAS FINANC S.A",
  "177": "GUIDE",
  "180": "CM CAPITAL MARKETS CCTVM LTDA",
  "182": "DACASA FINANCEIRA S/A",
  "183": "SOCRED S.A",
  "184": "BANCO ITAÚ BBA S.A",
  "188": "ATIVA S.A INVESTIMENTOS",
  "189": "HS FINANCEIRA",
  "190": "SERVICOOP",
  "191": "NOVA FUTURA CTVM LTDA",
  "194": "PARMETAL DTVM LTDA",
  "196": "BANCO FAIR CC S.A",
  "197": "STONE PAGAMENTOS S.A",
  "204": "BANCO BRADESCO CARTOES S.A",
  "208": "BANCO BTG PACTUAL S.A",
  "212": "BANCO ORIGINAL S.A",
  "213": "BCO ARBI S.A",
  "217": "BANCO JOHN DEERE S.A",
  "218": "BANCO BS2 S.A",
  "222": "BANCO CRÉDIT AGRICOLE BR S.A",
  "224": "BANCO FIBRA S.A",
  "233": "BANCO CIFRA",
  "237": "BRADESCO S.A",
  "241": "BANCO CLASSICO S.A",
  "243": "BANCO MÁXIMA S.A",
  "246": "BANCO ABC BRASIL S.A",
  "249": "BANCO INVESTCRED UNIBANCO S.A",
  "250": "BANCO BCV",
  "253": "BEXS CC S.A",
  "254": "PARANA BANCO S.A",
  "260": "NU PAGAMENTOS S.A (NUBANK)",
  "265": "BANCO FATOR S.A",
  "266": "BANCO CEDULA S.A",
  "268": "BARIGUI CH",
  "269": "HSBC BANCO DE INVESTIMENTO",
  "270": "SAGITUR CC LTDA",
  "271": "IB CCTVM LTDA",
  "273": "CCR DE SÃO MIGUEL DO OESTE",
  "276": "SENFF S.A",
  "278": "GENIAL INVESTIMENTOS CVM S.A",
  "279": "CCR DE PRIMAVERA DO LESTE",
  "280": "AVISTA S.A",
  "283": "RB CAPITAL INVESTIMENTOS DTVM LTDA",
  "285": "FRENTE CC LTDA",
  "286": "CCR DE OURO",
  "288": "CAROL DTVM LTDA",
  "290": "Pagseguro Internet S.A (PagBank)",
  "292": "BS2 DISTRIBUIDORA DE TÍTULOS E INVESTIMENTOS",
  "293": "LASTRO RDV DTVM LTDA",
  "298": "VIPS CC LTDA",
  "300": "BANCO LA NACION ARGENTINA",
  "301": "BPP INSTITUIÇÃO DE PAGAMENTOS S.A",
  "310": "VORTX DTVM LTDA",
  "318": "BANCO BMG S.A",
  "320": "BANCO CCB BRASIL S.A",
  "323": "Mercado Pago - conta do Mercado Livre",
  "335": "Banco Digio S.A",
  "336": "BANCO C6 S.A - C6 BANK",
  "340": "SUPER PAGAMENTOS S/A (SUPERDITAL)",
  "341": "ITAÚ UNIBANCO S.A",
  "348": "BANCO XP S/A",
  "364": "GERENCIANET PAGAMENTOS DO BRASIL",
  "366": "BANCO SOCIETE GENERALE BRASIL",
  "370": "BANCO MIZUHO S.A",
  "376": "BANCO J.P. MORGAN S.A",
  "380": "PicPay Servicos S.A.",
  "389": "BANCO MERCANTIL DO BRASIL S.A",
  "394": "BANCO BRADESCO FINANCIAMENTOS S.A",
  "399": "KIRTON BANK",
  "412": "BANCO CAPITAL S.A",
  "422": "BANCO SAFRA S.A",
  "456": "BANCO MUFG BRASIL S.A",
  "464": "BANCO SUMITOMO MITSUI BRASIL S.A",
  "473": "BANCO CAIXA GERAL BRASIL S.A",
  "477": "CITIBANK N.A",
  "479": "BANCO ITAUBANK S.A",
  "487": "DEUTSCHE BANK S.A BANCO ALEMÃO",
  "488": "JPMORGAN CHASE BANK",
  "492": "ING BANK N.V",
  "494": "BANCO REP ORIENTAL URUGUAY",
  "495": "LA PROVINCIA BUENOS AIRES BANCO",
  "505": "BANCO CREDIT SUISSE (BRL) S.A",
  "545": "SENSO CCVM S.A",
  "600": "BANCO LUSO BRASILEIRO S.A",
  "604": "BANCO INDUSTRIAL DO BRASIL S.A",
  "610": "BANCO VR S.A",
  "611": "BANCO PAULISTA",
  "612": "BANCO GUANABARA S.A",
  "613": "OMNI BANCO S.A",
  "623": "BANCO PAN",
  "626": "BANCO FICSA S.A",
  "630": "BANCO INTERCAP S.A",
  "633": "BANCO RENDIMENTO S.A",
  "634": "BANCO TRIANGULO S.A (BANCO TRIÂNGULO)",
  "637": "BANCO SOFISA S.A (SOFISA DIRETO)",
  "641": "BANCO ALVORADA S.A",
  "643": "BANCO PINE S.A",
  "652": "ITAÚ UNIBANCO HOLDING BM S.A",
  "653": "BANCO INDUSVAL S.A",
  "654": "BANCO DIGIMAIS S.A",
  "655": "BANCO VOTORANTIM S.A",
  "707": "BANCO DAYCOVAL S.A",
  "712": "BANCO OURINVEST S.A",
  "739": "BANCO CETELEM S.A",
  "741": "BANCO RIBEIRÃO PRETO",
  "743": "BANCO SEMEAR S.A",
  "745": "BANCO CITIBANK S.A",
  "746": "BANCO MODAL S.A",
  "747": "Banco RABOBANK INTERNACIONAL DO BRASIL S.A",
  "748": "SICREDI S.A",
  "751": "SCOTIABANK BRASIL",
  "752": "BNP PARIBAS BRASIL S.A",
  "753": "NOVO BANCO CONTINENTAL S.A BM",
  "754": "BANCO SISTEMA",
  "755": "BOFA MERRILL LYNCH BM S.A",
  "756": "BANCOOB (BANCO COOPERATIVO DO BRASIL)",
  "757": "BANCO KEB HANA DO BRASIL S.A",
  "237__1": "NEXT BANK (UTILIZAR O MESMO CÓDIGO DO BRADESCO)",
  "655__1": "NEON PAGAMENTOS S.A (OS MESMOS DADOS DO BANCO VOTORANTIM)",
  "389__1": "BANCO MERCANTIL DO BRASIL S.A.",
};
