<a href="https://assembly.com/think-200/bounties"><img src="https://asm-badger.herokuapp.com/think-200/badges/tasks.svg" height="24px" alt="Open Tasks" /></a>&nbsp;&nbsp;[![Code Climate](https://codeclimate.com/github/asm-products/think-200/badges/gpa.svg)](https://codeclimate.com/github/asm-products/think-200)

## Monitor your web services with TDD

This is a product being built by the Assembly community. You can help push this idea forward by visiting [https://assembly.com/think-200](https://assembly.com/think-200).

### How Assembly Works

Assembly products are like open-source and made with contributions from the community. Assembly handles the boring stuff like hosting, support, financing, legal, etc. Once the product launches we collect the revenue and split the profits amongst the contributors.

Visit [https://assembly.com](https://assembly.com) to learn more.


### Development Setup

A Vagrant-based development environment is ready to use:

1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. Install [Vagrant](https://www.vagrantup.com/)
3. copy `config/database.yml-default` to `config/database.yml`
4. Run the command `vagrant up`


### Notes

This is a sample server json response to the queue-status request:

```json
{
  "percent_complete": 80,
  "projects": {
    "1": {
      "queued": "true",
      "tested_at": 1394765771
    },
    "2": {
      "queued": "false",
      "tested_at": 1394765781
    },
    "3": {
      "queued": "false",
      "tested_at": 1394765783
    },
    "4": {
      "queued": "false",
      "tested_at": 1394765784
    },
    "5": {
      "queued": "false",
      "tested_at": 1394765785
    }
  }
}
```
