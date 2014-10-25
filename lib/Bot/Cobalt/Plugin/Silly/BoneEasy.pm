package Bot::Cobalt::Plugin::Silly::BoneEasy;
our $VERSION;
BEGIN {
  require Bot::Cobalt::Plugin::Silly;
  $VERSION = $Bot::Cobalt::Plugin::Silly::VERSION;
}

use 5.12.1;
use Bot::Cobalt::Common;

use Bone::Easy;

sub new { bless [], shift }

sub Cobalt_register {
  my ($self, $core) = splice @_, 0, 2;
  
  $core->plugin_register( $self, 'SERVER',
    'public_cmd_pickup'
  );
  
  $core->log->info("$VERSION loaded");

  return PLUGIN_EAT_NONE
}

sub Cobalt_unregister {
  my ($self, $core) = splice @_, 0, 2;

  $core->log->info("Unloaded");

  return PLUGIN_EAT_NONE
}

sub Bot_public_cmd_pickup {
  my ($self, $core) = splice @_, 0, 2;

  my $msg     = ${ $_[0] };
  my $context = $msg->context;

  my $resp = pickup;

  my $channel = $msg->channel;

  $core->send_event( 'send_message',
    $context,
    $channel,
    $resp
  ) if $resp;
  
  return PLUGIN_EAT_ALL
}

1;
__END__
=pod

=head1 NAME

Bot::Cobalt::Plugin::Silly::BoneEasy - Get pickup lines from Bone-Easy

=head1 SYNOPSIS

  !plugin load Bone Bot::Cobalt::Plugin::Silly::BoneEasy
  !pickup

=head1 DESCRIPTION

A L<Bot::Cobalt> plugin.

Simple bridge to L<Bone::Easy>.

Generates pickup lines that work every time, 60% of the time.

=head1 AUTHOR

Jon Portnoy <avenj@cobaltirc.org>

L<http://www.cobaltirc.org>

=cut
