require 'gmail-britta'

fs = GmailBritta.filterset(:me => [
  'josh@joshuaspence.com',
  'joshua.james.spence@gmail.com',
]) do

  # Finance: Accounting
  filter {
    from 'accounts@pocketsmith.com'
    label 'Finance/Accounting'
  }

  # Finance: Bank
  bank = filter {
    has [
      {:or => [
        'cba.com.au',
        'commbank.com.au',
        'commonwealthawards.com.au',
      ].map{|domain| "from:#{domain}"}},
    ]
    label 'Finance/Bank'
  }.archive_unless_directed
  bank.also {
    has [
      'from:NetBankNotification@cba.com.au',
      {:or => [
        'New account statement',
        'New credit card statement',
      ].map{|subject| "subject:\"#{subject}\""}},
    ]
    label 'Finance/Bank/Statements'
    mark_important
    star
  }
  bank.also {
    has [
      'from:NetBankNotification@cba.com.au',
      {:or => [
        '"We were unable to process one of your scheduled transfers."',
        '"Your scheduled transfer was successfully processed."',
      ]},
      '"From account:"',
      '"To account:"',
      '"Description:"',
      '"Amount:"',
    ]
    archive
    label 'Finance/Bank/Transfers'
  }.also {
    has ['"Your scheduled transfer was successfully processed."']
    mark_read
  }

  # Firearms: Dealers
  filter {
    has [
      {:or => [
        'brownells.com',
        'cleaverfirearms.com',
        'gunsngear.com.au',
        'safarifirearms.com.au',
      ].map{|domain| "from:#{domain}"}},
    ]
    label 'Firearms/Dealers'
  }.archive_unless_directed.also {
    label 'Firearms'
  }

  # Firearms: Political
  filter {
    has [
      {:or => [
        'Robert.Borsak@parliament.nsw.gov.au',
        'Robert.Brown@parliament.nsw.gov.au',
        'sfp.org.au',
      ].map{|email| "from:#{email}"}},
    ]
    label 'Firearms'
  }.archive_unless_directed

  # Firearms: Registry
  filter {
    has [
      {:or => [
        'clubs@police.nsw.gov.au',
        'dealers@police.nsw.gov.au',
        'firearmsenq@police.nsw.gov.au',
        'FRPTA@police.nsw.gov.au',
        'imports@police.nsw.gov.au',
        'permits@police.nsw.gov.au',
      ].map{|email| "from:#{email}"}},
    ]
    label 'Firearms/Registry'
  }.also {
    label 'Firearms'
  }

  # Invoices
  # TODO: Improve this filter
  filter {
    has [
      {:or => [
        {:or => [
          'Billing Statement',
          'Payment Receipt',
          'Tax Invoice',
          'Receipt for Purchase',
          'Order Receipt',
        ].map{|subject| "subject:\"#{subject}\""}},

        {:or => [
          'Tax Invoice',
        ].map{|text| "\"#{text}\""}},

        # Blacklisted senders
        {:or => [
          # eBay
          [
            'from:billing@ebay.com.au',
            'subject:"eBay Invoice Notification"',
          ],
          [
            'from:ebay@ebay.com.au',
            'subject:"Your invoice for eBay purchases"',
          ],

          # PayPal
          [
            'from:service@paypal.com.au',
            'subject:"Receipt for your payment"',
          ],

          # Roam
          [
            'from:enquiries@e.roam.com.au',
            'subject:"Your Roam Statement is available online"',
          ],

          # Telstra
          [
            'from:online.telstra.com',
            'subject:"Telstra bill for account"',
            'has:attachment',
          ],

          [
            'from:opalcustomercare@opal.com.au',
            'subject:"Your Opal card quarterly activity statement"',
            'has:attachment',
          ],

          [
            'from:amazon.com',
            'subject:"Amazon Web Services Billing Statement Available"',
          ]
        ]},
      ]},
    ]
    label 'Invoices'
    mark_important
    star
  }

  # Newsletters
  filter {
    has [
      {:or => [
        {:or => [
          '"Add to address book"',
          '"Add us to your address book"',
        ]},
        {:or => [
          '"Forward this email to a friend"',
          '"Forward to a friend"',
        ]},
        {:or => [
          '"You are receiving this email because you subscribed"',
          '"You have subscribed"',
          '"You received this email because you signed up"',
        ]},
        {:or => [
          '"Email not displaying correctly?"',
          '"To view this email as a web page"',
          '"View this online"',
        ]},
        {:or => [
          '"This email was automatically sent"',
        ]},
        {:or => [
          '"We hope you enjoyed receiving this message"',
          '"We want to stay in touch, but only if you want us to"',
        ]},
      ].combination(2).to_a},
      {:or => [
        '"Click here to unsubscribe"',
        '"If you do not want to receive e-mails"',
        '"If you no longer want us to contact you"',
        '"If you wish to not receive any other emails from us"',
        '"Manage your email settings or unsubscribe"',
        '"Rather not receive future emails"',
        '"Remove me from this list"',
        '"Remove yourself from this list"',
        '"To disable this communication"',
        '"To stop receiving emails"',
        '"Unsubscribe from this list"',
        '"Update subscription preferences"',
        '"You can also unsubscribe by writing to"',
        '"You can unsubscribe here"',
      ]},
    ]

    archive
    label 'Newsletters'
    mark_unimportant
  }

  filter {
    from [{or: [
      'deals@email.jbhifi.com.au',
      'info@email.thegoodguys.com.au',
      'kubeweekly@cncf.io',
      'marketing@email.harveynorman.com.au',
      'newsletters@moneymag.com.au',
      'pokemongo@news.nianticlabs.com',
    ]}]

    archive
    label 'Newsletters'
    mark_unimportant
  }

  # Newsletters (blacklist)
  filter {
    has [
      {:or => [
        'alumni.office@sydney.edu.au',
        'announcements@email.domain.com.au',
        'aws-apac-marketing@amazon.com',
        'aws-marketing-email-replies@amazon.com',
        'babybunting@edm.babybunting.com.au',
        'email.campaign@sg.booking.com',
        'info@mailer.netflix.com',
        'marriott@marriott-email.com',
        'noreply@updates.freelancer.com',
        'no-reply@yaffa.com.au',
        'nswshooter@nsw.ssaa.org.au',
        'promotions@ubnt.com',
        'qantasff@loyalty.qantas.com',
        'rewards@email.dansnews.com.au',
        'review@edm.realestate.com.au',
        'univsydney@acampaign.sydney.edu.au',
        'wyndhamrewards@e-mails.wyndhamrewards.com',
      ].map{|email| "from:#{email}"}},
    ]

    archive
    label 'Newsletters'
    mark_unimportant
  }

  # Orders
  # TODO: Improve this filter.
  filter {
    has [
      {:or => [
        {:or => [
          'Confirmation number',
          'Order confirmation',
          'Order details',
          'Order has shipped',
          'Shipping confirmation',
          'Tracking number',
        ].map{|text| "\"#{text}\""}},

        # Blacklisted senders
        {:or => [
          'auto-confirm@amazon.com',
          'order-update@amazon.com',
          'ship-confirm@amazon.com',
        ].map{|email| "from:#{email}"}},
      ]},
    ]
    label 'Orders'
  }

  # Phone: Telstra
  filter {
    from 'telstra.com'
    label 'Phone'
  }.archive_unless_directed

  # Pregnancy / Baby Newsletters
  filter {
    from 'babycentre@newsletters.babycentre.co.uk'

    archive
    label 'Newsletters'
  }.also {
    label 'Pregnancy'
  }

  # Projects: GitHub
  github = filter {
    from 'notifications@github.com'
    label 'Projects'
  }.archive_unless_directed

  # Projects: Phabricator
  phabricator = filter {
    from 'noreply@phabricator.com'
    label 'Projects'
  }.archive_unless_directed

  # Projects: Travis
  travis = filter {
    from 'notifications@travis-ci.org'
    label 'Projects'
  }.archive_unless_directed

  # Projects: arcanist
  github.also {
    has ['list:arcanist.phacility.github.com']
    label 'Projects/arcanist'
  }
  phabricator.also {
    has ['"REPOSITORY rARC Arcanist"']
    label 'Projects/arcanist'
  }

  # Projects: libphutil
  github.also {
    has ['list:libphutil.phacility.github.com']
    label 'Projects/libphutil'
  }
  phabricator.also {
    has ['"REPOSITORY rPHU libphutil"']
    label 'Projects/libphutil'
  }

  # Projects: Phabricator
  github.also {
    has ['list:phabricator.phacility.github.com']
    label 'Projects/Phabricator'
  }
  phabricator.also {
    has ['"REPOSITORY rP Phabricator"']
    label 'Projects/Phabricator'
  }

  # Social: Calendar
  filter {
    has ['filename:invite.ics']
    label 'Social/Calendar'
  }.also {
    label 'Social'
  }.also {
    subject 'Invitation'
    star
  }

  # Social: Facebook
  filter {
    from 'facebookmail.com'
    archive
    label 'Social/Facebook'
  }.also {
    label 'Social'
    smart_label 'social'
  }

  # Social: Google+
  filter {
    from 'plus.google.com'
    archive
    label 'Social/Google+'
  }.also {
    label 'Social'
    smart_label 'social'
  }

  # Social: LinkedIn
  filter {
    from 'linkedin.com'
    label 'Social/LinkedIn'
  }.also {
    has [
      {:or => [
        'invitations@linkedin.com',
        'messages-noreply@linkedin.com',
      ].map{|email| "from:#{email}"}},
    ]
    archive
  }.also {
    label 'Social'
    smart_label 'social'
  }

  # Social: Twitter
  filter {
    has [
      {:or => [
        'notify@twitter.com',
        'postmaster.twitter.com',
      ].map{|email| "from:#{email}"}},
    ]
    archive
    label 'Social/Twitter'
  }.also {
    label 'Social'
    smart_label 'social'
  }

  # Travel
  filter {
    from 'tripadvisor.com'
    label 'Travel'
  }

  # University
  filter {
    to 'jspe9969@uni.sydney.edu.au'
    label 'University'
  }.archive_unless_directed

  # Vehicle: Roam
  filter {
    has [
      {:or => [
        'receipt@transurban.com.au',
        'roam.com.au',
      ].map{|email| "from:#{email}"}},
    ]
    label 'Vehicle'
  }

  # Web: Amazon Web Services
  filter {
    has [
      {:or => [
        'amazon.com',
        'amazonaws.com',
      ].map{|email| "from:#{email}"}},
    ]
    label 'Web/Amazon Web Services'
  }.also {
    label 'Web'
  }

  # Web: Digital Pacific
  filter {
    from 'digitalpacific.com.au'
    label 'Web/Digital Pacific'
  }.also {
    label 'Web'
  }
end
puts fs.generate
