function cb()
{
  echo "--------------------"
  echo "$@"
  echo "--------------------"
  carthage build "$@" --platform iOS
}

cb actions
cb Async
cb Eureka
cb handyjson
cb SwiftyUserDefaults
