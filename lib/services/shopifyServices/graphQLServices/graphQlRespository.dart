import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../utils/cmsConfigue.dart';

class GraphQlRepository {
  static HttpLink httpLink = HttpLink(
    AppConfigure.baseUrl + APIConstants.graphQL,
    defaultHeaders: {
      'X-Shopify-Storefront-Access-Token': AppConfigure.storeFrontToken
    },
  );

  GraphQLClient clientToQuery() => GraphQLClient(
        cache: GraphQLCache(),
        link: httpLink,
      );
}
