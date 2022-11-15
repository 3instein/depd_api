part of 'pages.dart';

class Ongkirpage extends StatefulWidget {
  const Ongkirpage({Key? key}) : super(key: key);

  @override
  _OngkirpageState createState() => _OngkirpageState();
}

class _OngkirpageState extends State<Ongkirpage> {
  bool isLoading = false;
  String selectedCourier = 'jne';
  var kurir = [
    'jne',
    'tiki',
    'pos',
  ];

  final ctrlBerat = TextEditingController();

  dynamic originProvId;
  dynamic destinationProvId;
  dynamic originSelectedProv;
  dynamic destinationSelectedProv;
  dynamic originProvinceData;
  dynamic destinationProvinceData;
  Future<List<Province>> getProvinces() async {
    dynamic listProvince;
    await MasterDataService.getProvince().then((value) {
      setState(() {
        listProvince = value;
      });
    });

    return listProvince;
  }

  dynamic originCityId;
  dynamic originSelectedCity;
  dynamic destinationCityId;
  dynamic destinationSelectedCity;
  dynamic originCityData;
  dynamic destinationCityData;
  Future<List<City>> getOriginCities(dynamic provId) async {
    dynamic listCity;
    await MasterDataService.getCity(provId).then((value) {
      setState(() {
        listCity = value;
      });
    });

    return listCity;
  }

  Future<List<City>> getDestinationCities(dynamic provId) async {
    dynamic listCity;
    await MasterDataService.getCity(provId).then((value) {
      setState(() {
        listCity = value;
      });
    });

    return listCity;
  }

  List<Costs> listCosts = [];
  Future<dynamic> getCostsData() async {
    await RajaOngkirService.getMyOngkir(
            originSelectedCity.cityId,
            destinationSelectedCity.cityId,
            int.parse(ctrlBerat.text),
            selectedCourier)
        .then((value) {
      setState(() {
        listCosts = value;
        isLoading = false;
      });
      print(listCosts.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    originProvinceData = getProvinces();
    destinationProvinceData = getProvinces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Hitung Ongkir'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(children: [
              Flexible(
                flex: 3,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DropdownButton(
                            value: selectedCourier,
                            icon: const Icon(Icons.arrow_drop_down),
                            items: kurir.map((String value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              setState(() {
                                selectedCourier = value!;
                              });
                            },
                          ),
                          SizedBox(
                            width: 200,
                            child: TextFormField(
                                controller: ctrlBerat,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: 'Berat (gram)',
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Berat tidak boleh kosong';
                                  } else if (int.tryParse(value) == null) {
                                    return 'Berat harus angka';
                                  } else if (int.parse(value) < 1) {
                                    return 'Berat minimal 1 gram';
                                  } else {
                                    return null;
                                  }
                                }),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                        padding: EdgeInsets.all(16),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Origin',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 210,
                            child: FutureBuilder<List<Province>>(
                              future: originProvinceData,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return DropdownButton(
                                    isExpanded: true,
                                    value: originSelectedProv,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    iconSize: 30,
                                    elevation: 16,
                                    style: const TextStyle(color: Colors.black),
                                    hint: originSelectedProv == null
                                        ? const Text(
                                            'Pilih Provinsi!',
                                            style:
                                                TextStyle(color: Colors.black),
                                          )
                                        : Text(originSelectedProv.province),
                                    items: snapshot.data!
                                        .map<DropdownMenuItem<Province>>(
                                            (Province value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(value.province.toString()),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        originSelectedProv = newValue;
                                        originProvId =
                                            originSelectedProv.provinceId;
                                      });
                                      originSelectedCity = null;
                                      originCityData =
                                          getOriginCities(originProvId);
                                    },
                                  );
                                } else if (snapshot.hasError) {
                                  return const Text("Tidak ada data.");
                                }
                                return UiLoading.loadingDD();
                              },
                            ),
                          ),
                          SizedBox(
                            width: 210,
                            child: FutureBuilder<List<City>>(
                              future: originCityData,
                              builder: (context, snapshot) {
                                if (originCityData != null) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasData) {
                                      return DropdownButton(
                                          isExpanded: true,
                                          value: originSelectedCity,
                                          icon:
                                              const Icon(Icons.arrow_drop_down),
                                          iconSize: 30,
                                          elevation: 16,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          hint: originSelectedCity == null
                                              ? const Text('Pilih Kota!',
                                                  style: TextStyle(
                                                      color: Colors.black))
                                              : Text(
                                                  originSelectedCity.cityName),
                                          items: snapshot.data!
                                              .map<DropdownMenuItem<City>>(
                                                  (City value) {
                                            return DropdownMenuItem(
                                              value: value,
                                              child: Text(
                                                  value.cityName.toString()),
                                            );
                                          }).toList(),
                                          onChanged: ((value) {
                                            setState(() {
                                              originSelectedCity = value;
                                            });
                                          }));
                                    } else if (snapshot.hasError) {
                                      return const Text("Tidak ada data.");
                                    }
                                  }
                                  return UiLoading.loadingDD();
                                } else {
                                  return const Text("Pilih Provinsi dulu!");
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    const Padding(
                        padding: EdgeInsets.all(16),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Destination',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 210,
                            child: FutureBuilder<List<Province>>(
                              future: destinationProvinceData,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return DropdownButton(
                                    isExpanded: true,
                                    value: destinationSelectedProv,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    iconSize: 30,
                                    elevation: 16,
                                    style: const TextStyle(color: Colors.black),
                                    hint: destinationSelectedProv == null
                                        ? const Text(
                                            'Pilih Provinsi!',
                                            style:
                                                TextStyle(color: Colors.black),
                                          )
                                        : Text(
                                            destinationSelectedProv.province),
                                    items: snapshot.data!
                                        .map<DropdownMenuItem<Province>>(
                                            (Province value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(value.province.toString()),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        destinationSelectedProv = newValue;
                                        destinationProvId =
                                            destinationSelectedProv.provinceId;
                                      });
                                      destinationSelectedCity = null;
                                      destinationCityData =
                                          getDestinationCities(
                                              destinationProvId);
                                    },
                                  );
                                } else if (snapshot.hasError) {
                                  return const Text("Tidak ada data.");
                                }
                                return UiLoading.loadingDD();
                              },
                            ),
                          ),
                          SizedBox(
                            width: 210,
                            child: FutureBuilder<List<City>>(
                              future: destinationCityData,
                              builder: (context, snapshot) {
                                if (destinationCityData != null) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasData) {
                                      return DropdownButton(
                                          isExpanded: true,
                                          value: destinationSelectedCity,
                                          icon:
                                              const Icon(Icons.arrow_drop_down),
                                          iconSize: 30,
                                          elevation: 16,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          hint: destinationSelectedCity == null
                                              ? const Text('Pilih Kota!',
                                                  style: TextStyle(
                                                      color: Colors.black))
                                              : Text(destinationSelectedCity
                                                  .cityName),
                                          items: snapshot.data!
                                              .map<DropdownMenuItem<City>>(
                                                  (City value) {
                                            return DropdownMenuItem(
                                              value: value,
                                              child: Text(
                                                  value.cityName.toString()),
                                            );
                                          }).toList(),
                                          onChanged: ((value) {
                                            setState(() {
                                              destinationSelectedCity = value;
                                            });
                                          }));
                                    } else if (snapshot.hasError) {
                                      return const Text("Tidak ada data.");
                                    }
                                  }
                                  return UiLoading.loadingDD();
                                } else {
                                  return const Text("Pilih Provinsi dulu!");
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (originCityId.toString().isEmpty ||
                              destinationCityId.toString().isEmpty ||
                              selectedCourier.isEmpty ||
                              ctrlBerat.text.isEmpty) {
                            UiToast.toastErr("Semua field harus diisi!");
                          } else {
                            setState(() {
                              isLoading = true;
                            });
                            getCostsData();
                          }
                        },
                        child: const Text("Hitung estimasi harga"),
                      ),
                    )
                  ],
                ),
              ),
              Flexible(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: listCosts.isEmpty
                      ? const Align(
                          alignment: Alignment.center,
                          child: Text("Tidak ada data."),
                        )
                      : ListView.builder(
                          itemCount: listCosts.length,
                          itemBuilder: (context, index) {
                            return LazyLoadingList(
                                initialSizeOfItems: 10,
                                loadMore: () {},
                                child: CardOngkir(listCosts[index]),
                                index: index,
                                hasMore: true);
                          },
                        ),
                ),
              )
            ]),
          ),
          isLoading ? UiLoading.loading() : Container(),
        ],
      ),
    );
  }
}
