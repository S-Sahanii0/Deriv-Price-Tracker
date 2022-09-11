// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:price_tracker/app/app.dart';
import 'package:price_tracker/bootstrap.dart';
import 'package:price_tracker_api_client/price_tracker_api_client.dart';
import 'package:price_tracker_repository/price_tracker_repository.dart';

void main() {
  final _priceTrackerApiClient = PriceTrackerApiClient();
  final _priceTrackerRepository =
      PriceTrackerRepositoryImpl(priceTrackerApiClient: _priceTrackerApiClient);
  bootstrap(
    () => App(
      priceTrackerRepository: _priceTrackerRepository,
    ),
  );
}
