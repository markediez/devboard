Devboard.Models.Developer = Backbone.Model.extend(
  findAccountByType: (accountType) ->
    return _.find(this.get('accounts'), (account) ->
      return account.account_type == accountType
    )
)

Devboard.Collections.Developers = Backbone.Collection.extend(
  model: Devboard.Models.Developer
)
