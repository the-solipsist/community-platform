package DDGC::DB::Result::User::Notification;

use Moose;
extends 'DDGC::DB::Base::Result';
use DBIx::Class::Candy;
use namespace::autoclean;

table 'user_notification';

column id => {
	data_type => 'bigint',
	is_auto_increment => 1,
};
primary_key 'id';

column users_id => {
	data_type => 'bigint',
	is_nullable => 0,
};

# Context	ContextID	SubContext	Target
#-------------------------------------------------
# Y			X			Z			Changed/New Z on Y #X
# Y			X						Changes on Y #X
# Y									Changes on any Y or Changed/New Y
# Y						Z			New Z on any Y

column context => {
	data_type => 'text',
	is_nullable => 0,
};

column context_id => {
	data_type => 'bigint',
	is_nullable => 1,
};

column sub_context => {
	data_type => 'text',
	is_nullable => 1,
};

# not yet supported
column action => {
	data_type => 'text',
	is_nullable => 1,
};

# 1 = Instant (Not yet implemented)
# 2 = Hourly
# 3 = Daily
# 4 = Weekly

column cycle => {
	data_type => 'int',
	is_nullable => 0,
};

# not yet supported
column cycle_time => {
	data_type => 'timestamp with time zone',
	is_nullable => 1,
};

# not yet supported
column last_check => {
	data_type => 'timestamp with time zone',
	set_on_create => 1,
};

column created => {
	data_type => 'timestamp with time zone',
	set_on_create => 1,
};

belongs_to 'user', 'DDGC::DB::Result::User', 'users_id';

###############################

no Moose;
__PACKAGE__->meta->make_immutable;
