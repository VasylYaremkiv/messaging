User.create(username: 'admin', password: 'admin', role: User::ADMIN)
User.create(username: 'customer', password: 'customer', role: User::CUSTOMER, first_name: 'John', last_name: 'Doe')
