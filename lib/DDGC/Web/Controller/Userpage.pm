package DDGC::Web::Controller::Userpage;
# ABSTRACT: Userpage web controller class

use Moose;
use namespace::autoclean;

use DDGC::Config;

BEGIN {extends 'Catalyst::Controller'; }

sub base :Chained('/base') :PathPart('') :CaptureArgs(1) {
	my ( $self, $c, $username ) = @_;
	$c->stash->{user} = $c->d->find_user($username);
	unless ($c->stash->{user} && $c->stash->{user}->public) {
		return $c->go('/default');
	}
}

sub user :Chained('base') :PathPart('') :CaptureArgs(0) {
	my ( $self, $c ) = @_;
	my $username = $c->stash->{user}->username;
	$c->add_bc($username, $c->chained_uri('Userpage','home',$username));
	$c->stash->{up} = $c->stash->{user}->userpage;
	$c->stash->{userpage_home} = 1;
	$c->stash->{fields} = $c->stash->{up}->attribute_fields;
	$c->stash->{x} = $c->stash->{up}->export;
	$c->stash->{x}->{username} = $username;
	$c->stash->{title} = $username." User Page";
}

sub home :Chained('user') :PathPart('') :Args(0) {
	my ( $self, $c ) = @_;
	$c->bc_index;
}

sub json :Chained('user') :Args(0) {
    my ( $self, $c ) = @_;
	$c->forward('View::JSON');
}

no Moose;
__PACKAGE__->meta->make_immutable;
